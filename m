Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0775129B52F
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 16:12:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1793927AbgJ0PJI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 11:09:08 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:37544 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1793916AbgJ0PJF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 11:09:05 -0400
Received: by mail-lf1-f66.google.com with SMTP id j30so2787116lfp.4
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 08:09:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=+FNbNadygYiAOn8orc+ysECvjkbeojrWFCMMMDSrx/o=;
        b=K7FObG3Te7ksU8k3He78IFNNDIyyPV+3E2bn5kdH9lTcx4zGc2NocA358jmS3JuYi+
         PoNZdxYwZc43LyoX/d+CNqd+mraNOZ/8yp0o2+NPXXM70ye1XsKOFzdY1w+gK7F9Cs5M
         Fy7Tq37dEjV083zv25/AiGfQuj5z20TZXIsluca05AdoWtt2lkHqkH2W7sFQSSHiSKMO
         U1MIJ63aRVdgASAgrkTfP0eFc9D8BegDvsY8C0jV//r3z4EJ2lZdixHFzSrU8ag9vg0Y
         v9Yh3LTg6EP6EeaVJ600i1kvzErdMhYRcyHMEARoL9n4nipNWBc/AI2UsbX3GqcyYhot
         CH3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=+FNbNadygYiAOn8orc+ysECvjkbeojrWFCMMMDSrx/o=;
        b=Qb48sjWs2x6JaZO8KUzfA5Aty9FPDJgV2sMoR+hEpFRxDxbKU84Jm+sC35TqPqtK3Y
         fwczp+H0ZPssCeZYFwtqGkSXstqMGyl8xRVga+lZXqXNZDsuxusAeGykgkM7nn8utoqy
         beg1wqtfCZ2HI3fNfFxAdZx8rDISeun0Di5R+BWkoPKzksx2gE4kLxHPZmZXZLO3sNqq
         HqkOW8eqrVVR2+bHBx6O0MG1aiCgu4EcNFv2K4W0JHKHRI3FVdjYI3hAO1mrbytP6VA0
         FOMXeHftGEuTXDvQ3pidKI1MtzEvQgDk+fJVBPPY9Thm07XhJkC/GKp4hzHClrKaruJL
         kiSA==
X-Gm-Message-State: AOAM531+t5Wu3WogEtR/SGXN2k1SoaL1tVpzUOHU2k2lF3mCCXLZEo24
        YPmZlApoaZHNW5SYZbZxtyxkdHJlM19WNVp/
X-Google-Smtp-Source: ABdhPJxbBlenL9z4nSgruhDL2aoZUDmcWFn+mGnH8dN8m7mwSuNgPCuj4nYXQMUra1Nq6tu4ILOLPA==
X-Received: by 2002:a19:6902:: with SMTP id e2mr598027lfc.133.1603811342374;
        Tue, 27 Oct 2020 08:09:02 -0700 (PDT)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id c18sm202230lfh.98.2020.10.27.08.09.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 08:09:01 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] net: dsa: link aggregation support
In-Reply-To: <20201027140013.GC878328@lunn.ch>
References: <20201027105117.23052-1-tobias@waldekranz.com> <20201027140013.GC878328@lunn.ch>
Date:   Tue, 27 Oct 2020 16:09:01 +0100
Message-ID: <87r1pjvh82.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 27, 2020 at 15:00, Andrew Lunn <andrew@lunn.ch> wrote:
>> (mv88e6xxx) What is the policy regarding the use of DSA vs. EDSA?  It
>> seems like all chips capable of doing EDSA are using that, except for
>> the Peridot.
>
> Hi Tobias
>
> Marvell removed the ability to use EDSA, in the way we do in Linux
> DSA, on Peridot. One of the configuration bits is gone. So i had to
> use DSA.  It could be i just don't understand how to configure
> Peridot, and EDSA could be used, but i never figured it out.
>
> I will get back to your other questions.
>
>   Andrew

Hi Andrew,

Very interesting! Which bit is that?

Looking at the datasheets for Agate and Peridot side-by-side, the
sections named "Ether Type DSA Tag" seem to be identical.

Thanks,
Tobias
