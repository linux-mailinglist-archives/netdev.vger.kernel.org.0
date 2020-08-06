Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C26423DD0E
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 18:59:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729806AbgHFQ7d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 12:59:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728976AbgHFQkk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 12:40:40 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10E40C0A8936
        for <netdev@vger.kernel.org>; Thu,  6 Aug 2020 08:05:01 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id k18so17875022pfp.7
        for <netdev@vger.kernel.org>; Thu, 06 Aug 2020 08:05:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=9LGh6aG0DgsF81oiNMA4nsr14X/GrQw1MnhxCFp9lAc=;
        b=js1AQAOzT+yCV7GsAr1END9zFUZcP6094bE6mKe2EjTl4MXPQJGBeBXvo3QJagWpiZ
         m7WEL4J2aaNdz/ZMv2Va88qERvnrku8uZg7R2fJ9fgYi9kEjplVxiiik8prCaLReh7WF
         b/i9BUcNe7t9fB+mFl3YekPMvJq6Nak1Y+EAZt8rylNULmmynh/uAtIOM6pJVbU2hpEF
         WqlDEzKbtN/R5muFvnwBf95jbX8kATNlwmsS9Kk/dHTnu9/2L/jbHcrkG7+PFx0mQiYZ
         levZb1zlVZyNRGHPAsh8jN+zhWX/Ne4xKytIvtSmvgcp8DiNBLMYt4QMjORcgmvopIlx
         LsPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=9LGh6aG0DgsF81oiNMA4nsr14X/GrQw1MnhxCFp9lAc=;
        b=caSVDsj/OXhc79CxhXvfNAh5AZywkah4UUZ6ff4fQ/H49rCa6x7tzrEmOWgG/l64ax
         YQ/R5BNyzxtvZ6IwfClbJocKd26hstHWqDJiTl9SBleuLq9NVP/SG2/FYLlHJC+E3/wT
         vyO0/qfacn+FaRm3dKz8+uxWeFIVobpyczWrDnkXLdaCvpL3Fk+/zoymbOJk/ntWO5SB
         YeXyJlg+MC5ga+IxeuOJzoxOUZBp63FeDQ27JDKNS7OVLOGf6X0lHsMPcY03TGeU0P+d
         5GGci+0+LN2jM5a2DjlotJuErY9QMaAcB4fv3UULr+q7mw+qqLdjFTN25Sr0nR+mf+Py
         lWZg==
X-Gm-Message-State: AOAM533+Q63xdVOBa2yGymfUzWpN0VPfyoZuu/crffORbGlfgHGFrk/D
        OrvlRfxH5NgsHoSJvujXHOGlMrwXTSg=
X-Google-Smtp-Source: ABdhPJwAEEXxACKE4+NG+0aQlCVAyN1m+lye5CSzx2mdrND7qncjiP/WLwROs5FqkLD3inaOdwyzvw==
X-Received: by 2002:a63:31c6:: with SMTP id x189mr7543879pgx.182.1596726300151;
        Thu, 06 Aug 2020 08:05:00 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id w82sm8822755pff.7.2020.08.06.08.04.59
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2020 08:04:59 -0700 (PDT)
Date:   Thu, 6 Aug 2020 08:04:52 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 208833] New: applying HFSC causes soft lockup (probably
 related to pppoe)
Message-ID: <20200806080452.0693f8b2@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Thu, 06 Aug 2020 13:22:36 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 208833] New: applying HFSC causes soft lockup (probably related to pppoe)


https://bugzilla.kernel.org/show_bug.cgi?id=208833

            Bug ID: 208833
           Summary: applying HFSC causes soft lockup (probably related to
                    pppoe)
           Product: Networking
           Version: 2.5
    Kernel Version: 5.7
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: stephen@networkplumber.org
          Reporter: valahanovich@tut.by
        Regression: No

Created attachment 290795
  --> https://bugzilla.kernel.org/attachment.cgi?id=290795&action=edit  
example of my regular tc script

Applying and reapplying HFSC qdisc to interface with heavy load often causes
soft lockup (in random processes, in short time after applying qdisc).

Stack trace was somewhat uninformative and hard to get. I mostly observe this
with torrent client on PPPOE client interface when run attached script several
times.

Will attach dmesg as soon as i will be able to reliably get it.
I tried to bisect bug, but stopped at some old kernel that won't even boot with
my config. So the problem could be old but unnoticed.

-- 
You are receiving this mail because:
You are the assignee for the bug.
