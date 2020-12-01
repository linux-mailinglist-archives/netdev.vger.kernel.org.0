Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA5EB2C9CD6
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 10:39:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729198AbgLAJBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 04:01:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729136AbgLAJBf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 04:01:35 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BC27C0613CF
        for <netdev@vger.kernel.org>; Tue,  1 Dec 2020 01:00:47 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id y4so2067670edy.5
        for <netdev@vger.kernel.org>; Tue, 01 Dec 2020 01:00:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=3XPhZz7W/nBqE3Z80H7vj5wd6acNnTKZUv5BKfRnjj8=;
        b=Xl/wzP73Ws0as9TOVJ2NOB6hM7lC12jgzbNfr1AA/n1dhZT46hNiy3lgRpm0Nb1qbC
         +zwCPT1c/n/mhMmMJ7AEm2o4VfP3Kf52ZlnK5ea2kHs//pg8Tq4I0DbxGwJUnAslh8HF
         KaPSz3NkglFjfnzrP+ekAG8U2V8CCMueM/UvCrj/hNZGdqcei1Dt1LCeW59+KtY/uK34
         J+UWatmX6lwpH8QV0xiannhH7HQ8oCURMaE75EBETnS9W73QefwLaeczzzqaxYt9Et+p
         fS7Axxq3ubRDxo1+zvo8pcPji5lsrQ9M4VerJ31S3AXAz/Jv9xHl5gTl7DqjoK6PceKO
         4IkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=3XPhZz7W/nBqE3Z80H7vj5wd6acNnTKZUv5BKfRnjj8=;
        b=EC01uughtaxfnovej+rAFfRes5xRN0ebACzo4o8ZrnndIJEcIPhwkp9zcxnIMKV+O0
         n9P0WV9WiahAdEwf14JGt1EgnMs0SkL7vvLbk58tf9Gc+AF3jfRHFYKgotCH2WHYLYqW
         EDzjq1H1GWuKV1z1GGfHH+j4ZkhicMpChAKYINjZX/RPl+X/WnbUQmcADeAzfcMYnoGg
         eR//xcWJhv9ZfeozNCpTq1XRsBssQnMx8Jrf1DGgclxLtU87X9mb1P2vq1AfVCYPL7CW
         4lzUSvsoM81LQbx7Po+li1G4Pc6g35g01K1yZcDVnciUPPX1vMqklYM/pQwVFqWL3iXF
         dx+A==
X-Gm-Message-State: AOAM533bYCxLM+awIKcLYil0mNHyXZglu635GBUDPlEV+eACfocGAUGz
        KzkjwbsWOoi/8Z/jwXe6dbA=
X-Google-Smtp-Source: ABdhPJzDtxFI+6SFGWDV68LmxfUCuIunEm4Aim/R48cR6yNWGqHvuBXXrXNOHk/eg6eBdbwywhlOIQ==
X-Received: by 2002:a50:99cb:: with SMTP id n11mr1967449edb.362.1606813246190;
        Tue, 01 Dec 2020 01:00:46 -0800 (PST)
Received: from unassigned-hostname.unassigned-domain (x59cc8a5e.dyn.telefonica.de. [89.204.138.94])
        by smtp.gmail.com with ESMTPSA id v9sm516266ejk.48.2020.12.01.01.00.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Dec 2020 01:00:45 -0800 (PST)
Date:   Tue, 1 Dec 2020 10:00:42 +0100
From:   Peter Vollmer <peter.vollmer@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: dsa/mv88e6xxx: leaking packets on MV88E6341 switch
Message-ID: <20201201090041.GB6059@unassigned-hostname.unassigned-domain>
References: <CAGwvh_MAQWuKuhu5VuYjibmyN-FRxCXXhrQBRm34GShZPSN6Aw@mail.gmail.com>
 <20200930191956.GV3996795@lunn.ch>
 <20201001062107.GA2592@fido.de.innominate.com>
 <CAGwvh_PDtAH9bMujfvupfiKTi4CVKEWtp6wqUouUoHtst6FW1A@mail.gmail.com>
 <87y2in94o7.fsf@waldekranz.com>
 <20201126222359.GO2075216@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201126222359.GO2075216@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 26, 2020 at 11:23:59PM +0100, Andrew Lunn wrote:
> > > I tested setting .tag_protocol=DSA_TAG_PROTO_DSA for the 6341 switch
> > > instead, resulting in a register setting of 04 Port control for port 5
> > > = 0x053f (i.e. EgressMode=Unmodified mode, frames are transmitted
> > > unmodified), which looks correct to me. It does not fix the above
> > > problem, but the change seems to make sense anyhow. Should I send a
> > > patch ?
> > 
> > This is not up to me, but my guess is that Andrew would like a patch,
> > yes. On 6390X, I know for a fact that setting the EgressMode to 3 does
> > indeed produce the behavior that was supported in older devices (like
> > the 6352), but there is no reason not to change it to regular DSA.
> 
> I already said to Tobias, i had problems getting the 6390 working, and
> this was one of the things i changed. I don't think i ever undid this
> specific change, to see how critical it is. But relying on
> undocumented behaviour is not nice.
> 
> EDSA used to have the advantages that tcpdump understood it. But
> thanks to work Florian and Vivien did, tcpdump can now decode DSA just
> as well as EDSA.
> 
> So please do submit a patch.

I checked both cases (EDSA, DSA) with tcpdump on eth1 (SGMII to the switch),
they both seem to work and tcpdump recognizes two different formats, MEDSA for
DSA_TAG_PROTO_EDSA and "ethertype unknown (0x4018 (or 0xc018))" for
DSA_TAG_PROTO_DSA (due to an older tcpdump version 4.9.3 I guess). Maybe I can
get some information from our support if DSA_TAG_PROTO_EDSA is supported
for the port config (0x4) register on the 6341 switch after all or if it should
be omitted.

Thanks

  Peter
