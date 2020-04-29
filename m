Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F22E21BD2DC
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 05:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbgD2DXF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 23:23:05 -0400
Received: from smtprelay0177.hostedemail.com ([216.40.44.177]:32962 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726560AbgD2DXF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 23:23:05 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id 3D253182CED28;
        Wed, 29 Apr 2020 03:23:04 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3867:4321:5007:6119:6642:6997:10004:10400:10848:11026:11232:11473:11657:11658:11914:12043:12114:12296:12297:12438:12555:12740:12760:12895:12986:13439:14181:14659:14721:21080:21212:21451:21627:21990:30054:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: boy68_54e0c4c8a4616
X-Filterd-Recvd-Size: 3371
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf16.hostedemail.com (Postfix) with ESMTPA;
        Wed, 29 Apr 2020 03:23:03 +0000 (UTC)
Message-ID: <01d45e599732bc5af33a09b36e63beabfcad8d25.camel@perches.com>
Subject: Re: [PATCH -next] hinic: Use ARRAY_SIZE for nic_vf_cmd_msg_handler
From:   Joe Perches <joe@perches.com>
To:     Zou Wei <zou_wei@huawei.com>, aviad.krawczyk@huawei.com,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 28 Apr 2020 20:23:01 -0700
In-Reply-To: <1588130136-49236-1-git-send-email-zou_wei@huawei.com>
References: <1588130136-49236-1-git-send-email-zou_wei@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-04-29 at 11:15 +0800, Zou Wei wrote:
> fix coccinelle warning, use ARRAY_SIZE
> 
> drivers/net/ethernet/huawei/hinic/hinic_sriov.c:713:43-44: WARNING: Use ARRAY_SIZE
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zou Wei <zou_wei@huawei.com>
> ---
>  drivers/net/ethernet/huawei/hinic/hinic_sriov.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/huawei/hinic/hinic_sriov.c b/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
> index b24788e..ac12725 100644
> --- a/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
> +++ b/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
> @@ -710,8 +710,7 @@ int nic_pf_mbox_handler(void *hwdev, u16 vf_id, u8 cmd, void *buf_in,
>  	if (!hwdev)
>  		return -EFAULT;
>  
> -	cmd_number = sizeof(nic_vf_cmd_msg_handler) /
> -			    sizeof(struct vf_cmd_msg_handle);
> +	cmd_number = ARRAY_SIZE(nic_vf_cmd_msg_handler);
>  	pfhwdev = container_of(dev, struct hinic_pfhwdev, hwdev);
>  	nic_io = &dev->func_to_io;
>  	for (i = 0; i < cmd_number; i++) {

Probably better to remove cmd_number altogether
---
 drivers/net/ethernet/huawei/hinic/hinic_sriov.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_sriov.c b/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
index b24788..af70cc 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
@@ -704,17 +704,15 @@ int nic_pf_mbox_handler(void *hwdev, u16 vf_id, u8 cmd, void *buf_in,
 	struct hinic_hwdev *dev = hwdev;
 	struct hinic_func_to_io *nic_io;
 	struct hinic_pfhwdev *pfhwdev;
-	u32 i, cmd_number;
+	u32 i;
 	int err = 0;
 
 	if (!hwdev)
 		return -EFAULT;
 
-	cmd_number = sizeof(nic_vf_cmd_msg_handler) /
-			    sizeof(struct vf_cmd_msg_handle);
 	pfhwdev = container_of(dev, struct hinic_pfhwdev, hwdev);
 	nic_io = &dev->func_to_io;
-	for (i = 0; i < cmd_number; i++) {
+	for (i = 0; i < ARRAY_SIZE(nic_vf_cmd_msg_handler); i++) {
 		vf_msg_handle = &nic_vf_cmd_msg_handler[i];
 		if (cmd == vf_msg_handle->cmd &&
 		    vf_msg_handle->cmd_msg_handler) {
@@ -725,7 +723,7 @@ int nic_pf_mbox_handler(void *hwdev, u16 vf_id, u8 cmd, void *buf_in,
 			break;
 		}
 	}
-	if (i == cmd_number)
+	if (i == ARRAY_SIZE(nic_vf_cmd_msg_handler))
 		err = hinic_msg_to_mgmt(&pfhwdev->pf_to_mgmt, HINIC_MOD_L2NIC,
 					cmd, buf_in, in_size, buf_out,
 					out_size, HINIC_MGMT_MSG_SYNC);


