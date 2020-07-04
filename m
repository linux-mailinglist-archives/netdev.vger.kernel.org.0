Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 357A8214481
	for <lists+netdev@lfdr.de>; Sat,  4 Jul 2020 09:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbgGDHqI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jul 2020 03:46:08 -0400
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:64301 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726253AbgGDHqI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jul 2020 03:46:08 -0400
Received: from [192.168.1.7] (unknown [116.237.151.97])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id 4463F5C160F
        for <netdev@vger.kernel.org>; Sat,  4 Jul 2020 15:46:05 +0800 (CST)
Subject: Re: [PATCH net 2/2] net/sched: act_ct: add miss tcf_lastuse_update.
From:   wenxu <wenxu@ucloud.cn>
To:     netdev@vger.kernel.org
References: <1593848528-14234-1-git-send-email-wenxu@ucloud.cn>
Message-ID: <ef60d714-4a4d-5d94-e897-36689b6e9a95@ucloud.cn>
Date:   Sat, 4 Jul 2020 15:46:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <1593848528-14234-1-git-send-email-wenxu@ucloud.cn>
Content-Type: text/plain; charset=gbk
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVktVTEpOS0tLS0hISExDTUtKWVdZKF
        lBSUI3V1ktWUFJV1kPCRoVCBIfWUFZHSI1CzgcOTMVKRpDNgw5HRALCTE6HFZWVU5DS0IoSVlXWQ
        kOFx4IWUFZNTQpNjo3JCkuNz5ZV1kWGg8SFR0UWUFZNDBZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OU06HSo5CD5IKE44GQtREhAU
        KkxPCVZVSlVKTkJIQ09DTE1OSExJVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpKTVVJ
        SExVSk5KVUJMWVdZCAFZQUlKQ043Bg++
X-HM-Tid: 0a7318ca1b802087kuqy4463f5c160f
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please drop this one for wrong tags

ÔÚ 2020/7/4 15:42, wenxu@ucloud.cn Ð´µÀ:
> From: wenxu <wenxu@ucloud.cn>
>
> When tcf_ct_act execute the tcf_lastuse_update should
> be update or the used stats never update
>
> filter protocol ip pref 3 flower chain 0
> filter protocol ip pref 3 flower chain 0 handle 0x1
>   eth_type ipv4
>   dst_ip 1.1.1.1
>   ip_flags frag/firstfrag
>   skip_hw
>   not_in_hw
>  action order 1: ct zone 1 nat pipe
>   index 1 ref 1 bind 1 installed 103 sec used 103 sec
>  Action statistics:
>  Sent 151500 bytes 101 pkt (dropped 0, overlimits 0 requeues 0)
>  backlog 0b 0p requeues 0
>  cookie 4519c04dc64a1a295787aab13b6a50fb
>
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---
>  net/sched/act_ct.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
> index 2eaabdc..ec0250f 100644
> --- a/net/sched/act_ct.c
> +++ b/net/sched/act_ct.c
> @@ -928,6 +928,8 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
>  	force = p->ct_action & TCA_CT_ACT_FORCE;
>  	tmpl = p->tmpl;
>  
> +	tcf_lastuse_update(&c->tcf_tm);
> +
>  	if (clear) {
>  		ct = nf_ct_get(skb, &ctinfo);
>  		if (ct) {
