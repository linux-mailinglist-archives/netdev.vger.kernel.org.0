Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD90A1CFC43
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 19:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728324AbgELRef (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 13:34:35 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:46221 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbgELRee (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 13:34:34 -0400
Received: by mail-pf1-f196.google.com with SMTP id 145so6661666pfw.13;
        Tue, 12 May 2020 10:34:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=SoNFFWSLtismfgimMD9RRUqbG8Gc0vXuhqXQTxiHa3E=;
        b=tPCxRaLzCXXnwbe2PuVBrQB3zNf7ImYJ1VJlCNUzngrEYaYCz7DwyqdkyVxqD2Gk/O
         az1lxW1TZZluBsdWwAXY8cE5KIVStRiNRsuWrR/BQSqOJCTc/G0WlrFTRZvoZG88laKn
         5f01IcaB6gVjkzgG+blBwPhOgbKK1cNF8j6kQNv4DCymRqtESydTx2nMVyliwdYTsl3a
         5pRJd+jSXZjbJ0k+rW1peYw59pOWpmD24cKW0wYyGUcRt7WcDUUjrdfR5jYQqc2VySNJ
         xXboEf54RjurHJfz6GPnhYuI8M9yyeTtmujfehksiJBrr+cbW+if7Kmae1M1hcWOGH2f
         yEEg==
X-Gm-Message-State: AGi0Pua76oDs2bd6GlAsrIdtfWfulLiPQG9YW0Y6ujYmZgBg/QTRlstp
        WqemGWAmRjOxBILPZKFxkI8=
X-Google-Smtp-Source: APiQypJ+68+ear8ufjEOL0oNkkJk/Xpf8XwPIZhgKbKWlExgmSUkOQPWVDSh5T/eKdJojR2ORpx1vg==
X-Received: by 2002:a63:2347:: with SMTP id u7mr19974859pgm.183.1589304873617;
        Tue, 12 May 2020 10:34:33 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id g27sm1841905pfr.51.2020.05.12.10.34.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2020 10:34:31 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 41E0E4063E; Tue, 12 May 2020 17:34:31 +0000 (UTC)
Date:   Tue, 12 May 2020 17:34:31 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     jeyu@kernel.org, akpm@linux-foundation.org, arnd@arndb.de,
        rostedt@goodmis.org, mingo@redhat.com, aquini@redhat.com,
        cai@lca.pw, dyoung@redhat.com, bhe@redhat.com,
        peterz@infradead.org, tglx@linutronix.de, gpiccoli@canonical.com,
        pmladek@suse.com, tiwai@suse.de, schlad@suse.de,
        andriy.shevchenko@linux.intel.com, keescook@chromium.org,
        daniel.vetter@ffwll.ch, will@kernel.org,
        mchehab+samsung@kernel.org, kvalo@codeaurora.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>
Subject: Re: [EXT] [PATCH 09/15] qed: use new module_firmware_crashed()
Message-ID: <20200512173431.GD11244@42.do-not-panic.com>
References: <20200509043552.8745-1-mcgrof@kernel.org>
 <20200509043552.8745-10-mcgrof@kernel.org>
 <2aaddb69-2292-ff3f-94c7-0ab9dbc8e53c@marvell.com>
 <20200509164229.GJ11244@42.do-not-panic.com>
 <e10b611e-f925-f12d-bcd2-ba60d86dd8d0@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e10b611e-f925-f12d-bcd2-ba60d86dd8d0@marvell.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 12, 2020 at 07:23:28PM +0300, Igor Russkikh wrote:
> 
> >> So I think its not a good place to insert this call.
> >> Its hard to find exact good place to insert it in qed.
> > 
> > Is there a way to check if what happened was indeed a fw crash?
> 
> Our driver has two firmwares (slowpath and fastpath).
> For slowpath firmware the way to understand it crashed is to observe command
> response timeout. This is in qed_mcp.c, around "The MFW failed to respond to
> command" traceout.

Ok thanks.

> For fastpath this is tricky, think you may leave the above place as the only
> place to invoke module_firmware_crashed()

So do you mean like the changes below?

diff --git a/drivers/net/ethernet/qlogic/qed/qed_debug.c b/drivers/net/ethernet/qlogic/qed/qed_debug.c
index f4eebaabb6d0..95cb7da2542e 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_debug.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_debug.c
@@ -7906,6 +7906,7 @@ int qed_dbg_all_data(struct qed_dev *cdev, void *buffer)
 		rc = qed_dbg_grc(cdev, (u8 *)buffer + offset +
 				 REGDUMP_HEADER_SIZE, &feature_size);
 		if (!rc) {
+			module_firmware_crashed();
 			*(u32 *)((u8 *)buffer + offset) =
 			    qed_calc_regdump_header(cdev, GRC_DUMP,
 						    cur_engine,
diff --git a/drivers/net/ethernet/qlogic/qed/qed_mcp.c b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
index 280527cc0578..a818cf09dccf 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_mcp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
@@ -566,6 +566,7 @@ _qed_mcp_cmd_and_union(struct qed_hwfn *p_hwfn,
 		DP_NOTICE(p_hwfn,
 			  "The MFW failed to respond to command 0x%08x [param 0x%08x].\n",
 			  p_mb_params->cmd, p_mb_params->param);
+		module_firmware_crashed();
 		qed_mcp_print_cpu_info(p_hwfn, p_ptt);
 
 		spin_lock_bh(&p_hwfn->mcp_info->cmd_lock);

> >> One more thing is that AFAIU taint flag gets permanent on kernel, but
> > for
> >> example our device can recover itself from some FW crashes, thus it'd be
> >> transparent for user.
> > 
> > Similar things are *supposed* to recoverable with other device, however
> > this can also sometimes lead to a situation where devices are not usable
> > anymore, and require a full driver unload / load.
> > 
> >> Whats the logical purpose of module_firmware_crashed? Does it mean fatal
> >> unrecoverable error on device?
> > 
> > Its just to annotate on the module and kernel that this has happened.
> > 
> > I take it you may agree that, firmware crashing *often* is not good
> > design,
> > and these issues should be reported to / fixed by vendors. In cases
> > where driver bugs are reported it is good to see if a firmware crash has
> > happened before, so that during analysis this is ruled out.
> 
> Probably, but still I see some misalignment here, in sense that taint is about
> the kernel state, not about a hardware state indication.

The kernel carries the driver though, and the driver / subsystem can
often times act strange when this happens.

> devlink health could really be a much better candidate for such things.

That sounds fantastic, please Cc me on patches! However I still believe
we should register this event in the kernel for support purposes.

  Luis
