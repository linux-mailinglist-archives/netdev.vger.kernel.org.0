Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0C504692E6
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 10:46:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241407AbhLFJuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 04:50:15 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:6814 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241402AbhLFJuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 04:50:15 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B66lcLZ015338;
        Mon, 6 Dec 2021 09:46:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=pEwvVsZEI5PP7nuXqgg30DhtejGlwW6V5MdC3Sk87+w=;
 b=DW2eWuIAQ74UIJOsdJOanNCgOiLMgJD+UgX4HE3f+hX7lnZWD317FrAr02sEPelZxn0o
 yDaLFbiGI+/IAmftELVms+a8uxnzc3ucfvA01riIro91OPDqxkpUMZtQ8lOj1nBFtop6
 zP7G9SsfyKjFnPgoCRvSxwz6t0kQ+Xgkpx2yklkWwWbzhq5mdYUytRePglMfx6xR3nf2
 oiC09w1tsM6gJ9tutm8//qrAJy5WBFYabpayn6bVSrJGbP5GRLW7lUT5QKlB4faJiwSJ
 hN6Bwy1uu1vrVsJDcu1dM7X6dStlu34O/fkN6Gcq7uTzWBKMBUknYQSkD3n+AI/YqDTp DQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3csdjdb348-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Dec 2021 09:46:41 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B69kf1Q031792;
        Mon, 6 Dec 2021 09:46:41 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3csdjdb33p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Dec 2021 09:46:41 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B69gdVV028507;
        Mon, 6 Dec 2021 09:46:39 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma02fra.de.ibm.com with ESMTP id 3cqyy924vd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Dec 2021 09:46:39 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B69ka9a14680360
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 Dec 2021 09:46:37 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D29A54C05A;
        Mon,  6 Dec 2021 09:46:36 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4BBB64C052;
        Mon,  6 Dec 2021 09:46:36 +0000 (GMT)
Received: from [9.171.70.142] (unknown [9.171.70.142])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  6 Dec 2021 09:46:36 +0000 (GMT)
Message-ID: <07f2df6c-d7e5-9781-dae4-b0c2411c946c@linux.ibm.com>
Date:   Mon, 6 Dec 2021 11:46:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH net] ethtool: do not perform operations on net devices
 being unregistered
Content-Language: en-US
To:     Antoine Tenart <atenart@kernel.org>, davem@davemloft.net,
        kuba@kernel.org
Cc:     alexander.duyck@gmail.com, mkubecek@suse.cz, netdev@vger.kernel.org
References: <20211203101318.435618-1-atenart@kernel.org>
From:   Julian Wiedmann <jwi@linux.ibm.com>
In-Reply-To: <20211203101318.435618-1-atenart@kernel.org>
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: on-rwg8D9kteUMdBcsl2hyml_idkVtu6
X-Proofpoint-GUID: 2Hdhpaby81_nIWIcrclm6p9-uMXyvNlD
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-06_03,2021-12-06_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 malwarescore=0 clxscore=1011 phishscore=0 bulkscore=0 spamscore=0
 priorityscore=1501 suspectscore=0 impostorscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112060056
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03.12.21 12:13, Antoine Tenart wrote:
> There is a short period between a net device starts to be unregistered
> and when it is actually gone. In that time frame ethtool operations
> could still be performed, which might end up in unwanted or undefined
> behaviours[1].
> 
> Do not allow ethtool operations after a net device starts its
> unregistration. This patch targets the netlink part as the ioctl one
> isn't affected: the reference to the net device is taken and the
> operation is executed within an rtnl lock section and the net device
> won't be found after unregister.
> 
> [1] For example adding Tx queues after unregister ends up in NULL
>     pointer exceptions and UaFs, such as:
> 
>       BUG: KASAN: use-after-free in kobject_get+0x14/0x90
>       Read of size 1 at addr ffff88801961248c by task ethtool/755
> 
>       CPU: 0 PID: 755 Comm: ethtool Not tainted 5.15.0-rc6+ #778
>       Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-4.fc34 04/014
>       Call Trace:
>        dump_stack_lvl+0x57/0x72
>        print_address_description.constprop.0+0x1f/0x140
>        kasan_report.cold+0x7f/0x11b
>        kobject_get+0x14/0x90
>        kobject_add_internal+0x3d1/0x450
>        kobject_init_and_add+0xba/0xf0
>        netdev_queue_update_kobjects+0xcf/0x200
>        netif_set_real_num_tx_queues+0xb4/0x310
>        veth_set_channels+0x1c3/0x550
>        ethnl_set_channels+0x524/0x610
> 
> Fixes: 041b1c5d4a53 ("ethtool: helper functions for netlink interface")
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Antoine Tenart <atenart@kernel.org>
> ---
> 
> Following the discussions in those threads:
> - https://lore.kernel.org/all/20211129154520.295823-1-atenart@kernel.org/T/
> - https://lore.kernel.org/all/20211122162007.303623-1-atenart@kernel.org/T/
> 
>  net/ethtool/netlink.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
> index 38b44c0291b1..96f4180aabd2 100644
> --- a/net/ethtool/netlink.c
> +++ b/net/ethtool/netlink.c
> @@ -40,7 +40,8 @@ int ethnl_ops_begin(struct net_device *dev)
>  	if (dev->dev.parent)
>  		pm_runtime_get_sync(dev->dev.parent);
>  
> -	if (!netif_device_present(dev)) {
> +	if (!netif_device_present(dev) ||
> +	    dev->reg_state == NETREG_UNREGISTERING) {
>  		ret = -ENODEV;
>  		goto err;
>  	}
> 

Wondering if other places would also benefit from a netif_device_detach()
in the unregistration sequence ...
