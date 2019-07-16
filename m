Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1690569FC3
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 02:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731909AbfGPAYa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 20:24:30 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46682 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731009AbfGPAYa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 20:24:30 -0400
Received: by mail-pf1-f195.google.com with SMTP id c73so8180379pfb.13
        for <netdev@vger.kernel.org>; Mon, 15 Jul 2019 17:24:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=b+MXswfktJjsIPklLeKC/HiBNYnhM/1RZgyQhwO9/vY=;
        b=j1RoyySL1J2PYZdWvtFneh2ct3n+VVYg6adqZ681zrPs6NlbRTis4t5YI0oW7Co/Jz
         VNyeMhP5BrtuBg38Q6w2MbVXlIaKKuZQyK0s5Kh1bs6mrCRH7ZvxqypaXMcT5kSmruMy
         X18BOSW5VPftDkxkQSqTZSdiVZ7jYPxlsr6x0v8bRCDN+kxJcyhusmfOrR2zKgBrndEj
         glRdwZrOgG176DVJXrSsbehwylNJcckw6b5iyjfrdnOTNyo7ZRFAaHrr3YbGxbDitjY/
         RLbKz5kYyFArmbPfTjIV6F2d7GBmO7Dd1ws5YlOx/fqc/U/ES/cqTqX2tDCsExYyKhBx
         jyXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=b+MXswfktJjsIPklLeKC/HiBNYnhM/1RZgyQhwO9/vY=;
        b=BBzTP+j39tCxzZRBjerkyhMK9QODB86hsKCNxZBSs6TOudS0k6r0i5MONrcyBDKSn2
         0+7j6Vuy1sGq3G0WQcyy3BnThIFx9O5EoxnHsyFrGUd9UtVz0WII5JhKy0ofoHB4qneG
         8TpFmQZ/a2w3F7fdmt3amtPwYXn9qdcATvY2P3J+HmXCQxG2+7DIraoVi6M6cT7vmcWx
         fN/r06Y7JDGElM76J31f5lGpUq+8gD+DDcNkd6YPtdrHGaWFeS6eEobzrJE5weN0jf2l
         b0QDhHyWLhA8NDrW2UZg0F/cXCnQEcmiFoAyaWBXXhJUIFB8GJFNcwP/NDir0SL1pNJl
         iZmw==
X-Gm-Message-State: APjAAAVS9NsdDAp/lMlcskq9OTbB8wETacokdiDf/Ws3S21tZsCi7egl
        o+X7ZOY46pu5pAvtSqVn2HY=
X-Google-Smtp-Source: APXvYqzYCOfYSZXmCOFmIRbsGBdCeuMIE62IBOCMqH6QwPJvD5p3fNexcVpuEygzVv9p+54mMYjriw==
X-Received: by 2002:a17:90a:3463:: with SMTP id o90mr33084906pjb.15.1563236669523;
        Mon, 15 Jul 2019 17:24:29 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id e5sm22435411pfd.56.2019.07.15.17.24.29
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 15 Jul 2019 17:24:29 -0700 (PDT)
Date:   Mon, 15 Jul 2019 17:24:22 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Vedang Patel <vedang.patel@intel.com>, netdev@vger.kernel.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        vinicius.gomes@intel.com, leandro.maciel.dorileo@intel.com,
        m-karicheri2@ti.com, dsahern@gmail.com
Subject: Re: [PATCH iproute2 net-next v3 2/5] taprio: Add support for
 setting flags
Message-ID: <20190715172422.4e127da2@hermes.lan>
In-Reply-To: <20190715171515.248460a6@cakuba.netronome.com>
References: <1563231104-19912-1-git-send-email-vedang.patel@intel.com>
        <1563231104-19912-2-git-send-email-vedang.patel@intel.com>
        <20190715163743.2c6cec2b@hermes.lan>
        <20190715171515.248460a6@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 15 Jul 2019 17:15:15 -0700
Jakub Kicinski <jakub.kicinski@netronome.com> wrote:

> On Mon, 15 Jul 2019 16:37:43 -0700, Stephen Hemminger wrote:
> > On Mon, 15 Jul 2019 15:51:41 -0700
> > Vedang Patel <vedang.patel@intel.com> wrote:  
> > > @@ -442,6 +458,11 @@ static int taprio_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
> > >  
> > >  	print_string(PRINT_ANY, "clockid", "clockid %s", get_clock_name(clockid));
> > >  
> > > +	if (tb[TCA_TAPRIO_ATTR_FLAGS]) {
> > > +		taprio_flags = rta_getattr_u32(tb[TCA_TAPRIO_ATTR_FLAGS]);
> > > +		print_uint(PRINT_ANY, "flags", " flags %x", taprio_flags);
> > > +	}  
> >[...]
> > 3. Use the print_0xhex() instead of print_uint() for hex values. The difference
> >    is that in the JSON output, print_uint would be decimal but the print_0xhex
> >    is always hex.  And use "flags %#x" so that it is clear you are printing flags in hex.  
> 
> In my humble personal experience scripting tests using iproute2 and
> bpftool with Python I found printing the "hex string" instead of just
> outputing the integer value counter productive :( Even tho it looks
> better to the eye, JSON is primarily for machine processing and hex
> strings have to be manually converted.

If it is hex on normal output, it should be hex on JSON output.
And what ever the normal output format is has to be accepted on command line as input.
