Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7E75685B
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 14:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727272AbfFZMNA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 08:13:00 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40481 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726131AbfFZMM7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 08:12:59 -0400
Received: by mail-wm1-f67.google.com with SMTP id v19so1852124wmj.5
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 05:12:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=PEDhys7CAUKD9hBn6WdutR3jPjNvRJyuNsHNr3HtJgA=;
        b=rpsrZKV/4Yev7UhytrBsIU3tvYrodbpLXOLfgVVrqBdWD030AtEk9yb7rpXrZvt2w9
         KlD7LeXtBab3nTbMoOlnuC6PRv2irMqF/4z5XoFS1yhAYb/oEU1tPIngxMhG8NL9qHQY
         Q306XvnS1TpdvEuuy72O7e3+Rn9CVzYlzRLvK/vFJZK1CdgaYHh//EpxmJRDN6hskrfr
         XYuIPwSdD0rltJcgr8K3QREG+C3fcYqklqqERgoia4salcxU6G10CWl7RHDxr6JT6j80
         rY3/RNbRPxN02YgsksBVSwPZOUpj40JLXE2BR5PqajQXgiti6dGtpcD+Nj/7YReYjQ7F
         WH7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=PEDhys7CAUKD9hBn6WdutR3jPjNvRJyuNsHNr3HtJgA=;
        b=REAakpIGnSKq0mLd5O3AhufYAiZsM7TCTpkylavsJaFXLnE60g8sEaWtbESYZWNQcs
         4KQ8RMeOT2qov3fmrcM7W/Ie61BozMCF5RA+2dMHWxH/24iI/iVy0X6NfDhWXWTGewFF
         dB+iN3cKUmAb//VP5zvmIRgRmoNrN+VHDrMBGIwL5rAOUgvTDW3qKmKgrXrxEs1BYAR2
         rxkKX35h/Xc/jPPh0HP7ln7DJuqfK67wCoR9rFyiv3lK+mDgHnUg54FAwgu6C5u/YNj5
         sZzHTS4oC52BXGF1SZAZHvrjZ4bABC+a/y5kUGmQZJ545AUfHHtHKFRNRSkMexh9YGiL
         rSfw==
X-Gm-Message-State: APjAAAX13tqTXgkI621BFgLVGG/lq5i2VMsySTuKK1NgEy7ADjjkSkjq
        asiMac9+tlgqSY9iLnNR5ox/gA==
X-Google-Smtp-Source: APXvYqzgG862uFPcB4NCvIYRGovidIBSWkA4r+ZzURG+kE4pXtik3lOmP9Mys8kvjv98nV+xtC7oAw==
X-Received: by 2002:a05:600c:212:: with SMTP id 18mr2509286wmi.88.1561551178297;
        Wed, 26 Jun 2019 05:12:58 -0700 (PDT)
Received: from localhost (ip-89-176-222-26.net.upcbroadband.cz. [89.176.222.26])
        by smtp.gmail.com with ESMTPSA id u6sm2068595wml.9.2019.06.26.05.12.56
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 26 Jun 2019 05:12:56 -0700 (PDT)
Date:   Wed, 26 Jun 2019 14:12:56 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        davem@davemloft.net, thomas.lendacky@amd.com, f.fainelli@gmail.com,
        ariel.elior@cavium.com, michael.chan@broadcom.com,
        santosh@chelsio.com, madalin.bucur@nxp.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jeffrey.t.kirsher@intel.com, tariqt@mellanox.com,
        saeedm@mellanox.com, jiri@mellanox.com, idosch@mellanox.com,
        jakub.kicinski@netronome.com, peppe.cavallaro@st.com,
        grygorii.strashko@ti.com, andrew@lunn.ch,
        vivien.didelot@savoirfairelinux.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, linux-net-drivers@solarflare.com,
        ganeshgr@chelsio.com, ogerlitz@mellanox.com,
        Manish.Chopra@cavium.com, marcelo.leitner@gmail.com,
        mkubecek@suse.cz, venkatkumar.duvvuru@broadcom.com,
        cphealy@gmail.com
Subject: Re: [PATCH net-next 04/12] net: sched: add tcf_block_setup()
Message-ID: <20190626121256.GA2424@nanopsycho>
References: <20190620194917.2298-1-pablo@netfilter.org>
 <20190620194917.2298-5-pablo@netfilter.org>
 <20190621171603.GF2414@nanopsycho.orion>
 <20190625083154.jfzhh22zsl3fu2ik@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190625083154.jfzhh22zsl3fu2ik@salvia>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Jun 25, 2019 at 10:31:54AM CEST, pablo@netfilter.org wrote:
>On Fri, Jun 21, 2019 at 07:16:03PM +0200, Jiri Pirko wrote:
>> Thu, Jun 20, 2019 at 09:49:09PM CEST, pablo@netfilter.org wrote:
>> 
>> [...]
>> 
>> > 
>> >+static LIST_HEAD(tcf_block_cb_list);
>> 
>> I still don't like the global list. Have to go throught the code more
>> carefully, but why you can't pass the priv/ctx from tc/netfilter. From
>> tc it would be tcf_block as it is now, from netfilter something else.
>
>This tcf_block_cb_list should go away at some point, once drivers know
>how to deal with multiple subsystems using the setup block
>infrastructure. As I said in my previous email, only one can set up
>the block at this stage, the ones coming later will hit busy.

The driver should know if it can bind or is busy. Also, the bind cmd
should contain type of binder (tc/nft/whatever) or perhaps rather binder
priority (according to the hook order in rx/tx).
