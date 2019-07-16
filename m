Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF6C69FE6
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 02:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732751AbfGPAed (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 20:34:33 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:46754 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730355AbfGPAed (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 20:34:33 -0400
Received: by mail-qk1-f196.google.com with SMTP id r4so13122017qkm.13
        for <netdev@vger.kernel.org>; Mon, 15 Jul 2019 17:34:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=AQgO6xg4ck+X8dRplESnGe0PwiYHyG5i9HAU6due/R4=;
        b=HJhmcmPFD45Yn1y2cUcLDRF1WD8VII/bzgVAOmquEAkM9BCowk2mP+Hoe4eF32wEF6
         4Vhp2/LuswDmCHY6DKbNyXqUzhIikfKviBj87fgLoe6j/Nnx2Mc8rKEWSuRBSdLCei/X
         kFYuoastG3PWRh51zfJGsuUDW69KpkVzCa5sLh9zGLRo7V4H46fsm8DvqImdEZ/OILf/
         IOwp4loYGbqnx5jXGC5lCa14mnY7wtAeOEmNNEILfP8Maj62eNpcKxA4S7G0wxg2DcgV
         IR3tOeImOaKCWGcbbp5OzIRiCPSNc9VldTMWDZHz3UFxs+AZomFu63WHBSMArbXi4yPv
         xtrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=AQgO6xg4ck+X8dRplESnGe0PwiYHyG5i9HAU6due/R4=;
        b=X6fQkJVEMvbYVMSuG8QHnNvUhFho4KMYJ/fFIc47n1wISXgkVs0tZcdg95UrBFoEHi
         q+WWcDTBsIEnqdullJXlUfe2ouaTDhzrY+O2+hIiz9EcprtAZoAAFJCyFJWZg9nf0XtG
         CXsDvXfN7kQgGRRnjscn0NWpbZKJC67Jk7lOhOQdg5lCZx5vtf6H0/QhUBdYy9+xP3mk
         jGx/f1xo02meTGquHv2QwD0lWJ44nEURMuvh+qPICS5JkLieVe6ukZSoL7CAdiv2k3l0
         XEEXk8crusuGvB1vsx+opgjzWG5nPwdDN4yqCEd1UssMD4axvjJmMZyoiixCTBhSZ4JQ
         MP4w==
X-Gm-Message-State: APjAAAUfcXtPVdOxMZkdRkzBRFWnc9BfgtQZYSgE5V9r8E0EgFGGSL4N
        Zua17R/CONBGs5Z13hiPGb0U8g==
X-Google-Smtp-Source: APXvYqzEv91qGFCPpFBJI7k9WZMNQR+v2y7GkCMlplXoa8LVRUQBtH74nnqSpPi7UPcUNTetL+5nmg==
X-Received: by 2002:a05:620a:1497:: with SMTP id w23mr18805681qkj.49.1563237272475;
        Mon, 15 Jul 2019 17:34:32 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id c14sm7457896qko.84.2019.07.15.17.34.31
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 15 Jul 2019 17:34:32 -0700 (PDT)
Date:   Mon, 15 Jul 2019 17:34:27 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Vedang Patel <vedang.patel@intel.com>, netdev@vger.kernel.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        vinicius.gomes@intel.com, leandro.maciel.dorileo@intel.com,
        m-karicheri2@ti.com, dsahern@gmail.com
Subject: Re: [PATCH iproute2 net-next v3 2/5] taprio: Add support for
 setting flags
Message-ID: <20190715173427.783a0849@cakuba.netronome.com>
In-Reply-To: <20190715172422.4e127da2@hermes.lan>
References: <1563231104-19912-1-git-send-email-vedang.patel@intel.com>
        <1563231104-19912-2-git-send-email-vedang.patel@intel.com>
        <20190715163743.2c6cec2b@hermes.lan>
        <20190715171515.248460a6@cakuba.netronome.com>
        <20190715172422.4e127da2@hermes.lan>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 15 Jul 2019 17:24:22 -0700, Stephen Hemminger wrote:
> On Mon, 15 Jul 2019 17:15:15 -0700
> Jakub Kicinski <jakub.kicinski@netronome.com> wrote:
> > On Mon, 15 Jul 2019 16:37:43 -0700, Stephen Hemminger wrote:  
> > > On Mon, 15 Jul 2019 15:51:41 -0700
> > > Vedang Patel <vedang.patel@intel.com> wrote:    
> > > > @@ -442,6 +458,11 @@ static int taprio_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
> > > >  
> > > >  	print_string(PRINT_ANY, "clockid", "clockid %s", get_clock_name(clockid));
> > > >  
> > > > +	if (tb[TCA_TAPRIO_ATTR_FLAGS]) {
> > > > +		taprio_flags = rta_getattr_u32(tb[TCA_TAPRIO_ATTR_FLAGS]);
> > > > +		print_uint(PRINT_ANY, "flags", " flags %x", taprio_flags);
> > > > +	}    
> > >[...]
> > > 3. Use the print_0xhex() instead of print_uint() for hex values. The difference
> > >    is that in the JSON output, print_uint would be decimal but the print_0xhex
> > >    is always hex.  And use "flags %#x" so that it is clear you are printing flags in hex.    
> > 
> > In my humble personal experience scripting tests using iproute2 and
> > bpftool with Python I found printing the "hex string" instead of just
> > outputing the integer value counter productive :( Even tho it looks
> > better to the eye, JSON is primarily for machine processing and hex
> > strings have to be manually converted.  
> 
> If it is hex on normal output, it should be hex on JSON output.
> And what ever the normal output format is has to be accepted on command line as input.

Ah, I forgot the output == input principle in iproute2!
In any case if there was ever a vote whether to limit this principle to
non-JSON output, and make machines' life easier, I'd vote 'yes' :)
