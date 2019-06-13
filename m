Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7573B43BD8
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727194AbfFMPcD convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 13 Jun 2019 11:32:03 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:37451 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728561AbfFMKxj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 06:53:39 -0400
Received: by mail-ed1-f67.google.com with SMTP id w13so30595092eds.4
        for <netdev@vger.kernel.org>; Thu, 13 Jun 2019 03:53:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=xhSf5TT2mj6vcFz8c+MVMklmQCaapAS8dtApn+ewM4E=;
        b=GMGB4BWtZAiCip+IjytFslx1P/u0OdLKzPHY2trYCL+BA685/aceNaFSqiBDnQ3ABB
         Yr2JAcY2QJ2k2ptJOPN5KjukgYt+hhkHE1yGQ9mBQqXmtlRy54RO73sbCLoMFThM0ru0
         MZ1bpCs0FFPXqyfW+t7Gk2DUKR3757t0kmIUJPC5kycayZwMgJ8+U/4jJL901APcEYQf
         3rFZmaQt5rlUCjp4YtaCtffVw3Z419rnw8Hgn7aFdo5XVgsx18GL0JkNEmfNzAjL6gLk
         HifMnbNwbfu3/+qfLhoFE3ddCDqvMcg0HZEBs/a7FI8XrZfa70sffrGb02zIr5i1cet8
         llEw==
X-Gm-Message-State: APjAAAWpt7PKA9ZJ/UhDD6x7EJuEog1jEHUBcX/E1NlV5vRcbmIkDq54
        iZhK/Xx31D1pwKishno4dHbM3g==
X-Google-Smtp-Source: APXvYqxOP5p+9YKUfsHtda4z1zz8pd5dr4KOdDRF41/sEXJGSnxQds78S+K12KqyFY2J94vaulIdqw==
X-Received: by 2002:a17:906:1845:: with SMTP id w5mr15353092eje.0.1560423217645;
        Thu, 13 Jun 2019 03:53:37 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id h7sm749775edi.41.2019.06.13.03.53.36
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 13 Jun 2019 03:53:36 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 348FE1804AF; Thu, 13 Jun 2019 12:53:36 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>,
        Simon Horman <simon.horman@netronome.com>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        Paul Blakey <paulb@mellanox.com>,
        John Hurley <john.hurley@netronome.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Johannes Berg <johannes.berg@intel.com>,
        "dcaratti\@redhat.com" <dcaratti@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH net-next v6] net: sched: Introduce act_ctinfo action
In-Reply-To: <97632F5C-6AB9-4B71-8DE6-A2A3ED02226A@darbyshire-bryant.me.uk>
References: <20190528170236.29340-1-ldir@darbyshire-bryant.me.uk> <20190612180239.GA3499@localhost.localdomain> <20190612114627.4dd137ab@cakuba.netronome.com> <20190613083329.dmkmpl3djd3lewww@netronome.com> <97632F5C-6AB9-4B71-8DE6-A2A3ED02226A@darbyshire-bryant.me.uk>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 13 Jun 2019 12:53:36 +0200
Message-ID: <87pnnheoy7.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk> writes:

>> On 13 Jun 2019, at 10:33, Simon Horman <simon.horman@netronome.com> wrote:
>> 
>> On Wed, Jun 12, 2019 at 11:46:27AM -0700, Jakub Kicinski wrote:
>>> On Wed, 12 Jun 2019 15:02:39 -0300, Marcelo Ricardo Leitner wrote:
>>>> On Tue, May 28, 2019 at 05:03:50PM +0000, Kevin 'ldir' Darbyshire-Bryant wrote:
>>>> ...
>>>>> +static int tcf_ctinfo_init(struct net *net, struct nlattr *nla,
>>>>> +			   struct nlattr *est, struct tc_action **a,
>>>>> +			   int ovr, int bind, bool rtnl_held,
>>>>> +			   struct tcf_proto *tp,
>>>>> +			   struct netlink_ext_ack *extack)
>>>>> +{
>>>>> +	struct tc_action_net *tn = net_generic(net, ctinfo_net_id);
>>>>> +	struct nlattr *tb[TCA_CTINFO_MAX + 1];
>>>>> +	struct tcf_ctinfo_params *cp_new;
>>>>> +	struct tcf_chain *goto_ch = NULL;
>>>>> +	u32 dscpmask = 0, dscpstatemask;
>>>>> +	struct tc_ctinfo *actparm;
>>>>> +	struct tcf_ctinfo *ci;
>>>>> +	u8 dscpmaskshift;
>>>>> +	int ret = 0, err;
>>>>> +
>>>>> +	if (!nla)
>>>>> +		return -EINVAL;
>>>>> +
>>>>> +	err = nla_parse_nested(tb, TCA_CTINFO_MAX, nla, ctinfo_policy, NULL);
>>>>                                                                       ^^^^
>>>> Hi, two things here:
>>>> Why not use the extack parameter here? Took me a while to notice
>>>> that the EINVAL was actually hiding the issue below.
>>>> And also on the other two EINVALs this function returns.
>>>> 
>>>> 
>>>> Seems there was a race when this code went in and the stricter check
>>>> added by
>>>> b424e432e770 ("netlink: add validation of NLA_F_NESTED flag") and
>>>> 8cb081746c03 ("netlink: make validation more configurable for future
>>>> strictness").
>>>> 
>>>> I can't add these actions with current net-next and iproute-next:
>>>> # ~/iproute2/tc/tc action add action ctinfo dscp 0xfc000000 0x01000000
>>>> Error: NLA_F_NESTED is missing.
>>>> We have an error talking to the kernel
>>>> 
>>>> This also happens with the current post of act_ct and should also
>>>> happen with the act_mpls post (thus why Cc'ing John as well).
>>>> 
>>>> I'm not sure how we should fix this. In theory the kernel can't get
>>>> stricter with userspace here, as that breaks user applications as
>>>> above, so older actions can't use the more stricter parser. Should we
>>>> have some actions behaving one way, and newer ones in a different way?
>>>> That seems bad.
>>>> 
>>>> Or maybe all actions should just use nla_parse_nested_deprecated()?
>>>> I'm thinking this last. Yet, then the _deprecated suffix may not make
>>>> much sense here. WDYT?
>>> 
>>> Surely for new actions we can require strict validation, there is
>>> no existing user space to speak of..  Perhaps act_ctinfo and act_ct
>>> got slightly confused with the race you described, but in principle
>>> there is nothing stopping new actions from implementing the user space
>>> correctly, right?
>> 
>> FWIW, that is my thinking too.
>
>
> Hi everyone,
>
> Apologies that somehow I seem to have caused a bit of trouble.  If need be
> and because act_ctinfo hasn’t yet actually been released anything could happen
> to it, reverted if need be.  I’d like it to be done right, not that I know
> what right is, the perils of inexperience and copy/pasting existing boilerplate
> code.
>
> Looking at other code I think I should have done something like:
>
> diff --git a/net/sched/act_ctinfo.c b/net/sched/act_ctinfo.c
> index e78b60e47c0f..4695aa76c0dc 100644
> --- a/net/sched/act_ctinfo.c
> +++ b/net/sched/act_ctinfo.c
> @@ -168,7 +168,7 @@ static int tcf_ctinfo_init(struct net *net, struct nlattr *nla,
>         if (!nla)
>                 return -EINVAL;
>
> -       err = nla_parse_nested(tb, TCA_CTINFO_MAX, nla, ctinfo_policy, NULL);
> +       err = nla_parse_nested(tb, TCA_CTINFO_MAX, nla, ctinfo_policy, extack);
>         if (err < 0)
>                 return err;
>
> @@ -182,13 +182,19 @@ static int tcf_ctinfo_init(struct net *net, struct nlattr *nla,
>                 dscpmask = nla_get_u32(tb[TCA_CTINFO_PARMS_DSCP_MASK]);
>                 /* need contiguous 6 bit mask */
>                 dscpmaskshift = dscpmask ? __ffs(dscpmask) : 0;
> -               if ((~0 & (dscpmask >> dscpmaskshift)) != 0x3f)
> +               if ((~0 & (dscpmask >> dscpmaskshift)) != 0x3f) {
> +                       NL_SET_ERR_MSG_ATTR(extack, tb[TCA_CTINFO_PARMS_DSCP_MASK],
> +                                       "dscp mask must be 6 contiguous bits");
>                         return -EINVAL;
> +               }
>                 dscpstatemask = tb[TCA_CTINFO_PARMS_DSCP_STATEMASK] ?
>                         nla_get_u32(tb[TCA_CTINFO_PARMS_DSCP_STATEMASK]) : 0;
>                 /* mask & statemask must not overlap */
> -               if (dscpmask & dscpstatemask)
> +               if (dscpmask & dscpstatemask) {
> +                       NL_SET_ERR_MSG_ATTR(extack, tb[TCA_CTINFO_PARMS_STATEMASK],
> +                                       "dscp statemask must not overlap dscp mask");
>                         return -EINVAL;
> +               }
>         }
>
>         /* done the validation:now to the actual action allocation */
>
> Warning: Not even compile tested!  Am I heading in the right
> direction?

Yup! Sending a follow-up patch with an update like this would be an
excellent way to fix the issue :)

-Toke
