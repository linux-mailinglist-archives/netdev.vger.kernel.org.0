Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 645B337FD5
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 23:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728673AbfFFVqs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 17:46:48 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42579 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728665AbfFFVqr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 17:46:47 -0400
Received: by mail-pg1-f195.google.com with SMTP id e6so2078430pgd.9
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 14:46:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OcyALJXHO8dG3lOjKnND306wARQASlx5XvLP7GUnfIs=;
        b=Eq+bR8LVFKRRLMd86r23CBS9gh4PdDUxZ9jX5Cg0YKgAKdyHCFXYt2xAW/jz1Et1nf
         xWVSpj2W64pX68jDU4z4A5UwMMpuQ2wXPxXJZYwOBv5WL/FRmoRN9vG9HXvhNQY4zTJQ
         EY+ASy/k1MrZYxYu5nlr/EkW077S0yCk6WQ0Z3eo5Gvtof4EX+sQT+GTFTdmK42TMfyf
         AGcPSb42CPY5HMljh8pAd5bSTdJUHQc1rmNkeGJmu8LTpJb90cU5pDLLrX2n585dE1XZ
         2Hde/klIc2YhOpiu1ysKnCi31vE6btU/XIXTGnKaK4SxrR1N8bsnQH07p2Fd9hVkrxfv
         QUrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OcyALJXHO8dG3lOjKnND306wARQASlx5XvLP7GUnfIs=;
        b=ifENX96ni293hIML3F9NdGKPRq7P8lLeIeOMErDd0RciFKTgwfF6+Oo4RalCbDpb4R
         2G48dw3F+COekSEM7BLhsoKf3bPr5H5WdhEMpVXHSH4WbUecOlVdmXo3/AyaRkZf2ouz
         /l8n0ZUlyqUFdDe2Gqm95PF0jSbGrU7EKv/mVdxMTzOABemX0INro2+9OCT5SR6UTpLZ
         e5omBbHHEj+yhY35LydSUF+bLJHmJKAHE7fFSE7pcSYTRJlfyiBSj7LZhqIuHiQAlk6b
         eEA4WW2PRqbZglTiCN46thmFihKdLnqri+cIC5QVEfAoDN3oCxlqwUHW0xbnxE2E6x1w
         ojhA==
X-Gm-Message-State: APjAAAW44RW1MnFToLX7HUYH/TpmO6YjBORILUaGl/tORia+GFtuuaXk
        CZoiG03Vskr+lEGeBdSYLd4gnw==
X-Google-Smtp-Source: APXvYqyKyLRcFPTmz5edcKr/6jDhI8fqeZWN6X1O7En54SUb46iizLRFIQd5mQnhplU2t55AUwXYmA==
X-Received: by 2002:a62:e917:: with SMTP id j23mr49939639pfh.55.1559857606596;
        Thu, 06 Jun 2019 14:46:46 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id y10sm107641pfm.68.2019.06.06.14.46.45
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 06 Jun 2019 14:46:46 -0700 (PDT)
Date:   Thu, 6 Jun 2019 14:46:40 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     "Patel, Vedang" <vedang.patel@intel.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "Dorileo, Leandro" <leandro.maciel.dorileo@intel.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "m-karicheri2@ti.com" <m-karicheri2@ti.com>
Subject: Re: [PATCH iproute2 net-next v1 3/6] taprio: Add support for
 enabling offload mode
Message-ID: <20190606144640.1611428d@hermes.lan>
In-Reply-To: <E3C41041-64E5-4C95-9057-1F2A0E6ECEAC@intel.com>
References: <1559843541-12695-1-git-send-email-vedang.patel@intel.com>
        <1559843541-12695-3-git-send-email-vedang.patel@intel.com>
        <20190606124349.653454ab@hermes.lan>
        <E3C41041-64E5-4C95-9057-1F2A0E6ECEAC@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 6 Jun 2019 21:13:50 +0000
"Patel, Vedang" <vedang.patel@intel.com> wrote:

> > On Jun 6, 2019, at 12:43 PM, Stephen Hemminger <stephen@networkplumber.org> wrote:
> > 
> > On Thu,  6 Jun 2019 10:52:18 -0700
> > Vedang Patel <vedang.patel@intel.com> wrote:
> >   
> >> @@ -405,6 +420,7 @@ static int taprio_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
> >> 	struct rtattr *tb[TCA_TAPRIO_ATTR_MAX + 1];
> >> 	struct tc_mqprio_qopt *qopt = 0;
> >> 	__s32 clockid = CLOCKID_INVALID;
> >> +	__u32 offload_flags = 0;
> >> 	int i;
> >> 
> >> 	if (opt == NULL)
> >> @@ -442,6 +458,11 @@ static int taprio_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
> >> 
> >> 	print_string(PRINT_ANY, "clockid", "clockid %s", get_clock_name(clockid));
> >> 
> >> +	if (tb[TCA_TAPRIO_ATTR_OFFLOAD_FLAGS])
> >> +		offload_flags = rta_getattr_u32(tb[TCA_TAPRIO_ATTR_OFFLOAD_FLAGS]);
> >> +
> >> +	print_uint(PRINT_ANY, "offload", " offload %x", offload_flags);  
> > 
> > I don't think offload flags should be  printed at all if not present.
> > 
> > Why not?  
> Will make this in the next version.

Mostly this is so that output doesn't change for users who aren't using offload or have old kernel.
