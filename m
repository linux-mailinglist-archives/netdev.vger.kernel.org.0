Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A20BC39A4D3
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 17:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbhFCPmQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 11:42:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbhFCPmP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 11:42:15 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA317C06174A
        for <netdev@vger.kernel.org>; Thu,  3 Jun 2021 08:40:15 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id q15so5420976pgg.12
        for <netdev@vger.kernel.org>; Thu, 03 Jun 2021 08:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ak/IZSwFVeM9PvIqJks3Hzw5DOU/ylDLxFhneR4tQWQ=;
        b=iosFoA4eCM4vbdv5CJtkWPNDMJ+Sfw5dgTEdJz8CazAvU16DrR8PExooZtstNtlguQ
         8DUiB2vW4QNcRki8lP56IJlfsaCJwxUZSTEZE+xPtVJuNybrR1IxxVtfPMYOMeuEnk6c
         yAJtCGmGGKnzGsAIkvJZusgn55VmucQHdhylU5aj6aUROrm6q/L2Ep343Cw2aWzP5MwF
         od/KurunYV/dGLSmcfBUtu8VzGxyRhITJgSJltNF4YUTz9zRiK2xXZ7N6jy9GfJgze5z
         yXUwrnTEgBw54sbd4O03xt8GqazURLkj7R0HlU59czwkoytrlsm9lYbgmivryTaQ1PPW
         ixsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ak/IZSwFVeM9PvIqJks3Hzw5DOU/ylDLxFhneR4tQWQ=;
        b=R0v8ss4ZhRIQZia/a7sVihxX1F6Uxyu8Av/Zhkw8f+bCtoT9eqEDHQmy5EjlCRRBdX
         TfsVFECLht6HExWJ2ywS5AHle+6nzgDtLswMgsEGmgBReo6O273iMBVQgIjKUQli5Tgj
         396CQuwgltw23c73J1VQDq/bxoIeHJt3PA6vLW4RkbbuZRdgsgHq0C+hReQhcjyLkM7r
         u1PDLWYkNjgQQ5ifrPvo35O7xpXxSLalKGHp4XyjDNAJkZbkqc3T45HuFn7EAkNg9Hi2
         BCCzBlYvUlU8pf3VpODrYfrS16RFsKicphixl+HHWx5Y4EwxKj/+KrbsZUHktiZug3ko
         oe0g==
X-Gm-Message-State: AOAM533HG9Rnij4mALh1NTDxy+NQuM/LEyT+vs8gjA0ZB4MCOwisnvJ3
        +WGfl9zr9hY45fJ6NAfsdvh3a+CGbgX8aw==
X-Google-Smtp-Source: ABdhPJzcQFtOvsd5fBAchFdA4QgC8p4oDOZC7rNFBbJUro33dzw20xH9BMbMHKGeaYaI69+n9yOkJQ==
X-Received: by 2002:a62:3682:0:b029:2dd:ed69:6e85 with SMTP id d124-20020a6236820000b02902dded696e85mr17230pfa.20.1622734815377;
        Thu, 03 Jun 2021 08:40:15 -0700 (PDT)
Received: from hermes.local (76-14-218-44.or.wavecable.com. [76.14.218.44])
        by smtp.gmail.com with ESMTPSA id l11sm1392700pjh.28.2021.06.03.08.40.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 08:40:15 -0700 (PDT)
Date:   Thu, 3 Jun 2021 08:40:06 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Roi Dayan <roid@nvidia.com>
Cc:     David Ahern <dsahern@gmail.com>, <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Paul Blakey <paulb@nvidia.com>
Subject: Re: [PATCH iproute2-next] police: Add support for json output
Message-ID: <20210603084006.3e3c9b4b@hermes.local>
In-Reply-To: <a745235f-ff64-3f7f-1264-198649795856@nvidia.com>
References: <20210527130742.1070668-1-roid@nvidia.com>
        <e107ce61-58bf-d106-3891-46c83e3bfe8f@gmail.com>
        <a745235f-ff64-3f7f-1264-198649795856@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 3 Jun 2021 10:27:55 +0300
Roi Dayan <roid@nvidia.com> wrote:

> On 2021-06-02 5:29 PM, David Ahern wrote:
> > On 5/27/21 7:07 AM, Roi Dayan wrote:  
> >> @@ -300,13 +300,13 @@ static int print_police(struct action_util *a, FILE *f, struct rtattr *arg)
> >>   	    RTA_PAYLOAD(tb[TCA_POLICE_RATE64]) >= sizeof(rate64))
> >>   		rate64 = rta_getattr_u64(tb[TCA_POLICE_RATE64]);
> >>   
> >> -	fprintf(f, " police 0x%x ", p->index);
> >> +	print_int(PRINT_ANY, "police", "police %d ", p->index);  
> > 
> > this changes the output format from hex to decimal.
> >   
> 
> hmm thanks for the review. actually I see another issue with this.
> I missed this but this should actually be split into "kind" and "index".
> And index should be unsigned as the other actions.
> so we should have kind printed at the top of the function even if arg
> is null and index here.
> 
>          print_string(PRINT_ANY, "kind", "%s", "police"); 
> 
>          if (arg == NULL) 
> 
>                  return 0;
> ...
>          print_uint(PRINT_ANY, "index", "\t index %u ", p->index); 
> 
> 
> 
> then the json output should be this
> 
>             "actions": [ {
>                      "order": 1,
>                      "kind": "police",
>                      "index": 1,
> 
> 
> i'll send v2.
> 
> 
> >   
> >>   	tc_print_rate(PRINT_FP, NULL, "rate %s ", rate64);
> >>   	buffer = tc_calc_xmitsize(rate64, p->burst);
> >>   	print_size(PRINT_FP, NULL, "burst %s ", buffer);
> >>   	print_size(PRINT_FP, NULL, "mtu %s ", p->mtu);
> >>   	if (show_raw)
> >> -		fprintf(f, "[%08x] ", p->burst);
> >> +		print_hex(PRINT_FP, NULL, "[%08x] ", p->burst);
> >>   
> >>   	prate64 = p->peakrate.rate;
> >>   	if (tb[TCA_POLICE_PEAKRATE64] &&  
> > 
> >   

One useful check is to run your JSON output into python parser to be sure it is valid
