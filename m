Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8926379125
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 16:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239609AbhEJOoC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 10:44:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343664AbhEJOmI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 10:42:08 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30937C0611C9
        for <netdev@vger.kernel.org>; Mon, 10 May 2021 07:01:36 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id z6so16763764wrm.4
        for <netdev@vger.kernel.org>; Mon, 10 May 2021 07:01:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iwluQalwZkec5cyA7r65WlmzvifV1qbVPB/8Q+Z7xPI=;
        b=MvCPnanx6Fey1Pb/tOBedz6rASFkYahh3obJM4R51HEaQ6759yRPvnn25JmJDrsFKs
         jjFku4Zulslk3vLRRDmMHrqqNXqlnYLORhji8+kI5tmtXm3r/olDblGt89yV1x6RflSt
         Ddj3XRHiG/Wbsn3YGdP9yqlp0eM+ZptjgXrKVUCdmYXaHfaw/Ez07UoZbxajeOI5v7dd
         QIVItkXgXhARZDfv0v3Sep5UfqfFJRvxO9KYWMH4K3Jof8AmGLEdwIYYndEi/1djpGdK
         ec9AHR5y6nLWaF3WHIjXgOVWyMYrZn8xp5hzwXJHPJtADiy1HU3Cpk30I+peFnnVONqR
         i3jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iwluQalwZkec5cyA7r65WlmzvifV1qbVPB/8Q+Z7xPI=;
        b=ab3BG3PDOa+s7F48xnZRNWrufdi8oyPfIU51N8VOOuXq4H549aZSdhVqxZU5duI8ed
         OX89BDFNjqx/Jl0mgmZY+wefkpkBBSPeLh+DP596U2ynxf2H9SQzMXJj9wao+F9hKx71
         iUn77hjMeNKiWrKQLEjwFxjFW6QmkmVS2wRMjaSUsDEsbLiXVX9O7Nm6SWffKsEOI+dz
         HkMssJeoCfU0yl4a3x+DL2dHNQbfpJSyeoQl6El1922+4OGynFTKXsHIXD72xRGPuCPq
         aKhQs6dVv77Q3YDhrmPISf0ar8bzOneTh7Hp+wyyhr1TZdXKw82ds3w7M6az230dvdeL
         FKNQ==
X-Gm-Message-State: AOAM532UaDEJwA98joCBOA69vvVsKaXzPFM7ehcH6G9ncTZN8lktP20P
        k+qa+VhbGcvPdFjCm3Kl6pvoPcJa9Usy8tvD8V8=
X-Google-Smtp-Source: ABdhPJxRTVTC0px7Ae+skp2sAlduZvPMfrZCucnwt2VcDlr2aPofb9huuv8DrT6sJYa7huQIcWeogiuGwpMJxqqZ7xQ=
X-Received: by 2002:adf:cd06:: with SMTP id w6mr30817590wrm.93.1620655294851;
 Mon, 10 May 2021 07:01:34 -0700 (PDT)
MIME-Version: 1.0
References: <20210416204500.2012073-1-anthony.l.nguyen@intel.com>
 <20210416204500.2012073-3-anthony.l.nguyen@intel.com> <20210416141247.7a8048ad@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <b2850afee64efb6af2415cb3db75d4de14f3a1e2.camel@intel.com> <CADSoG1uYJGygF9rm+15BE4gy=RU9EBbmGv_+pzddrKLJLdV14w@mail.gmail.com>
In-Reply-To: <CADSoG1uYJGygF9rm+15BE4gy=RU9EBbmGv_+pzddrKLJLdV14w@mail.gmail.com>
From:   Nick Lowe <nick.lowe@gmail.com>
Date:   Mon, 10 May 2021 15:01:18 +0100
Message-ID: <CADSoG1uRgX2CtNa-sXoXBP5uCj3y5EnEspis_FYy+3YPY7upZA@mail.gmail.com>
Subject: Re: [PATCH net-next 2/6] igb: Add double-check MTA_REGISTER for i210
 and i211
To:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Cc:     "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Siwik, Grzegorz" <grzegorz.siwik@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Switzer, David" <david.switzer@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Or better, make attempt increment instead of the original decrement:

+     int i;
+     int attempt;
+     for (i = hw->mac.mta_reg_count - 1; i >= 0; i--) {
+          for (attempt = 1; attempt <= 3; attempt++) {
+               if (array_rd32(E1000_MTA, i) != hw->mac.mta_shadow[i]) {
+                    array_wr32(E1000_MTA, i, hw->mac.mta_shadow[i]);
+                    wrfl();
+
+                    if (attempt == 3 && array_rd32(E1000_MTA, i) !=
hw->mac.mta_shadow[i]) {
+                         hw_dbg("Failed to update MTA_REGISTER %d,
too many retries\n", i);
+                    }
+               }
+          }
+     }
