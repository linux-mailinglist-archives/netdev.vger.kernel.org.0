Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36927635F3A
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 14:21:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236126AbiKWNVk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 08:21:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236567AbiKWNVT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 08:21:19 -0500
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25C021255C8;
        Wed, 23 Nov 2022 05:00:12 -0800 (PST)
Received: by mail-ot1-x334.google.com with SMTP id p10-20020a9d76ca000000b0066d6c6bce58so11127136otl.7;
        Wed, 23 Nov 2022 05:00:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=K4ZYfQ//8JxmSnWwTP0M4RgT7Cewn6kgcf+fVm07+o0=;
        b=f9SGocttobr5iv9AxBeSrp68swrh9OM7wb0KL9CDgUQWBKoY77+CJkljw5GKxw9pVr
         fKlWq4DBHLeRCYMQbS4kzz67FrL82Od/qtOST+m+z6DI0sijQ4M9hdRy2n0NSq2y3TmZ
         HpLmtclTjoES5rp2G7elHSGvX4IUMAHPkideWT2/q93pgT1RaA2mmh1Kj9tTSY3AiZFY
         f677+wFiRBS+/jcHEknbqfLYstuzUDDhkAtEsoUmoR1aiBtViAs2EvCDjndjA7L9Nwvo
         s4L+O8Ats4YDySCw96awSp/w7sYzJIVTIaPUMUSucJz/mhyDRWuWGD835lmP71pN2iX7
         PoRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K4ZYfQ//8JxmSnWwTP0M4RgT7Cewn6kgcf+fVm07+o0=;
        b=j24jbCp/1XJJLa5+nnovk2qI+wqHnFbD2qklqsBcnogulpfhdxE6b+d56uqWW0bZr+
         xf+9saIuhWg1yIzMJToUbbkimPs5uSgubEb0/EdrxeHV9vipG/gt8WyOKe2RnA/PO0Wb
         JyR1xuJsM2mQH91w/AjzoR1BzynKTIG9+ajB7+YPaCWEhyDv24zILFJfCaJ+yoQKZmXz
         fWubsppYmrJujSrPIlpBts4PH+LFVu9Nh7QFRyJT3rzwburZ6kUgjErQMVRd0l7npPvB
         6gTas+WkGSHqd9r/PG/27WHOr1h8Gt9uAE/y0mhyYdcOrDdmyhrQI13OJm+EZ+3poXSL
         C5Gg==
X-Gm-Message-State: ANoB5plUQlxIuqOF1pact+3zvQHT4h+Y05m6aGSZ2PwNnJoLXlhJml+C
        QdRGfd1XwITcLjPNKPL1GaA=
X-Google-Smtp-Source: AA0mqf5b3W1P7Ye05qcAkMoY5K2OkuivuV2/hQ7idLXXh+0tdtrFJIbVWPqsny6OhdgQwh7ePtxd/g==
X-Received: by 2002:a9d:6486:0:b0:66d:ca7a:8b1a with SMTP id g6-20020a9d6486000000b0066dca7a8b1amr5914858otl.55.1669208407200;
        Wed, 23 Nov 2022 05:00:07 -0800 (PST)
Received: from t14s.localdomain ([2001:1284:f016:5412:fa8e:2d33:bd7c:54c7])
        by smtp.gmail.com with ESMTPSA id k17-20020a0568301bf100b0066dfa0d9c1dsm3114806otb.11.2022.11.23.05.00.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 05:00:06 -0800 (PST)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id 18B5C459C23; Wed, 23 Nov 2022 10:00:04 -0300 (-03)
Date:   Wed, 23 Nov 2022 10:00:04 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Firo Yang <firo.yang@suse.com>
Cc:     vyasevich@gmail.com, nhorman@tuxdriver.com, mkubecek@suse.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        firogm@gmail.com
Subject: Re: [PATCH 1/1] sctp: sysctl: referring the correct net namespace
Message-ID: <Y34ZVEeSryB0UTFD@t14s.localdomain>
References: <20221123094406.32654-1-firo.yang@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123094406.32654-1-firo.yang@suse.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 23, 2022 at 05:44:06PM +0800, Firo Yang wrote:
> Recently, a customer reported that from their container whose
> net namespace is different to the host's init_net, they can't set
> the container's net.sctp.rto_max to any value smaller than
> init_net.sctp.rto_min.
> 
> For instance,
> Host:
> sudo sysctl net.sctp.rto_min
> net.sctp.rto_min = 1000
> 
> Container:
> echo 100 > /mnt/proc-net/sctp/rto_min
> echo 400 > /mnt/proc-net/sctp/rto_max
> echo: write error: Invalid argument
> 
> This is caused by the check made from this'commit 4f3fdf3bc59c
> ("sctp: add check rto_min and rto_max in sysctl")'
> When validating the input value, it's always referring the boundary
> value set for the init_net namespace.
> 
> Having container's rto_max smaller than host's init_net.sctp.rto_min
> does make sense. Considering that the rto between two containers on the
> same host is very likely smaller than it for two hosts.

Makes sense. And also, here, it is not using the init_net as
boundaries for the values themselves. I mean, rto_min in init_net
won't be the minimum allowed for rto_min in other netns. Ditto for
rto_max.

More below.

> 
> So to fix this problem, just referring the boundary value from the net
> namespace where the new input value came from shold be enough.
> 
> Signed-off-by: Firo Yang <firo.yang@suse.com>
> ---
>  net/sctp/sysctl.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/net/sctp/sysctl.c b/net/sctp/sysctl.c
> index b46a416787ec..e167df4dc60b 100644
> --- a/net/sctp/sysctl.c
> +++ b/net/sctp/sysctl.c
> @@ -429,6 +429,9 @@ static int proc_sctp_do_rto_min(struct ctl_table *ctl, int write,
>  	else
>  		tbl.data = &net->sctp.rto_min;
>  
> +	if (net != &init_net)
> +		max = net->sctp.rto_max;

This also affects other sysctls:

$ grep -e procname -e extra sysctl.c | grep -B1 extra.*init_net
                .extra1         = SYSCTL_ONE,
                .extra2         = &init_net.sctp.rto_max
                .procname       = "rto_max",
                .extra1         = &init_net.sctp.rto_min,
--
                .extra1         = SYSCTL_ZERO,
                .extra2         = &init_net.sctp.ps_retrans,
                .procname       = "ps_retrans",
                .extra1         = &init_net.sctp.pf_retrans,

And apparently, SCTP is the only one doing such dynamic limits. At
least in networking.

While the issue you reported is fixable this way, for ps/pf_retrans,
it is not, as it is using proc_dointvec_minmax() and it will simply
consume those values (with no netns translation).

So what about patching sctp_sysctl_net_register() instead, to update
these pointers during netns creation? Right after where it update the
'data' one in there:

        for (i = 0; table[i].data; i++)
                table[i].data += (char *)(&net->sctp) - (char *)&init_net.sctp;

Thanks,
Marcelo

> +
>  	ret = proc_dointvec(&tbl, write, buffer, lenp, ppos);
>  	if (write && ret == 0) {
>  		if (new_value > max || new_value < min)
> @@ -457,6 +460,9 @@ static int proc_sctp_do_rto_max(struct ctl_table *ctl, int write,
>  	else
>  		tbl.data = &net->sctp.rto_max;
>  
> +	if (net != &init_net)
> +		min = net->sctp.rto_min;
> +
>  	ret = proc_dointvec(&tbl, write, buffer, lenp, ppos);
>  	if (write && ret == 0) {
>  		if (new_value > max || new_value < min)
> -- 
> 2.26.2
> 
