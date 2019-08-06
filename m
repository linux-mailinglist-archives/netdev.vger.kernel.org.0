Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E29B183627
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 18:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732048AbfHFQFQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 12:05:16 -0400
Received: from correo.us.es ([193.147.175.20]:45086 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728927AbfHFQFQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Aug 2019 12:05:16 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id F3008BA1AD
        for <netdev@vger.kernel.org>; Tue,  6 Aug 2019 18:05:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E063A1150B9
        for <netdev@vger.kernel.org>; Tue,  6 Aug 2019 18:05:13 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D5CBC512D2; Tue,  6 Aug 2019 18:05:13 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A96B1DA730;
        Tue,  6 Aug 2019 18:05:11 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 06 Aug 2019 18:05:11 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (149.103.108.93.rev.vodafone.pt [93.108.103.149])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 170F24265A31;
        Tue,  6 Aug 2019 18:05:10 +0200 (CEST)
Date:   Tue, 6 Aug 2019 18:05:09 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu@ucloud.cn
Cc:     jakub.kicinski@netronome.com, jiri@resnulli.us,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v6 5/6] flow_offload: support get
 multi-subsystem block
Message-ID: <20190806160509.qrldfktw37qqorae@salvia>
References: <1564925041-23530-1-git-send-email-wenxu@ucloud.cn>
 <1564925041-23530-6-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1564925041-23530-6-git-send-email-wenxu@ucloud.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 04, 2019 at 09:24:00PM +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> It provide a callback list to find the blocks of tc
> and nft subsystems
> 
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---
> v6: new patch
> 
>  include/net/flow_offload.h | 10 +++++++++-
>  net/core/flow_offload.c    | 47 +++++++++++++++++++++++++++++++++-------------
>  net/sched/cls_api.c        |  9 ++++++++-
>  3 files changed, 51 insertions(+), 15 deletions(-)
> 
> diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
> index 8f1a7b8..6022dd0 100644
> --- a/include/net/flow_offload.h
> +++ b/include/net/flow_offload.h
> @@ -375,6 +375,15 @@ typedef void flow_indr_block_ing_cmd_t(struct net_device *dev,
>  					void *cb_priv,
>  					enum flow_block_command command);
>  
> +struct flow_indr_block_ing_entry {
> +	flow_indr_block_ing_cmd_t *cb;
> +	struct list_head	list;
> +};
> +
> +void flow_indr_add_block_ing_cb(struct flow_indr_block_ing_entry *entry);
> +
> +void flow_indr_del_block_ing_cb(struct flow_indr_block_ing_entry *entry);

Twice the same?
