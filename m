Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61DF2184C5C
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 17:22:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbgCMQWb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 12:22:31 -0400
Received: from mail-lf1-f48.google.com ([209.85.167.48]:39147 "EHLO
        mail-lf1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726406AbgCMQWa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 12:22:30 -0400
Received: by mail-lf1-f48.google.com with SMTP id j15so8391226lfk.6
        for <netdev@vger.kernel.org>; Fri, 13 Mar 2020 09:22:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intelligence.org; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=4iQUS3k1PPvS58gHcgCugysQ/zIU+LpAs7H7OyDaCOk=;
        b=DMP27bC5m0hUKFZg44witqcHFc8tEbNdaMYfSbE2gbRHu/T5aJ6CD47lMuoZ3KCG7j
         YQZj3w2H+9GzYQtjjsP4UYKLaqTbzEU7hzltUd6QhvWUki8z2plG4j6E0Fv8pdOETou3
         /nD2lg/ASUvvSuqkO/uTOBawAtg7D6y2Aw6IgS8g0z3jUH963x158j2bdHLvKp7yTEWs
         DLOQn79q3oCJCbFMyXbANCrDPXabo/JHlcYKtqWEQ/RSBn4GACv1JcBGBRF8h+44UU/T
         K3XI+geoy3zZ27rwYJn4IXDtM30jrEd2jANrRhOa5LqorWyROX1azXcq6QviFWkNPfUh
         DRCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=4iQUS3k1PPvS58gHcgCugysQ/zIU+LpAs7H7OyDaCOk=;
        b=KmWNu7lSY1yJknPN7gUH3aJwSB53W9+wVqrCmSs46YttkEOIgvfzAz6fCKR06zDHEc
         MeN1cMOMINXm1thv5c6Z745/I+klUEwqMfBRgoE85xZajTdoOnn5gV1b/yhPGL1GsjIN
         KFWoD0NNQxScwiEGAKolo1i35aBSx8v+fMK/akwBwxiALb/ZexHSeANxWKKrn05rE6rv
         RqjJoMh6vlOnsaOkntICXTApXoe6R+4g6z1JyhS/VzzDGgP69jvzxVgMIIYY+aEqzKy9
         OqE645d4+c3T0AiBl8gUVRiH17Zew4alMoYO5tjC5wmI4T20ZhXmpLljrwKog1HL0kiO
         7ePQ==
X-Gm-Message-State: ANhLgQ3IHnvEVToDgSUoVsGxtrUtqQQEJZCvCuzU2FpjjfXtnAB+Zejq
        9VrmAj6iKLhEKZam4j20GCFh2oRlxk+7rnQqZwgkI1C579lp
X-Google-Smtp-Source: ADFU+vukXOL7JRCS1Dn/CaUpX0dIt5xSu+XrjT/SutWhnZ6bOnNVXHBg06cF4/+DLhcxVzEMJD39MWmfaWBbVdebbcc=
X-Received: by 2002:a05:6512:2001:: with SMTP id a1mr8837817lfb.141.1584116548298;
 Fri, 13 Mar 2020 09:22:28 -0700 (PDT)
MIME-Version: 1.0
From:   Chuck <chuck@intelligence.org>
Date:   Fri, 13 Mar 2020 09:21:52 -0700
Message-ID: <CAPwpnyTDpkX2hxiqYLxTuMM38cq+whPSC0yoee-YPLEAwfvqpQ@mail.gmail.com>
Subject: How to set domainname with iproute2? (net-tools deprecation)
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I see calls to move the world from net-tools to iproute2 [1] [2] [3].

My Linux distro uses the `hostname` executable from net-tools to set the
hostname, which simply passes it through to the `sethostname` system call.
I don't see any references to `sethostname` in the iproute2 sources.  I
guess the replacement is systemd's `hostnamectl set-hostname`?

My distro uses the `domainname` executable (which is a symlink to
`hostname`) from net-tools to set the domain name, which simply passes it
through to the `setdomainname` system call.  I don't see any calls
to `sethostname` in either iproute2 or systemd.

What is the recommended way to set the domain name during system
start-up without net-tools?

(Asking here because iproute2 is supposed to replace net-tools.  If this is
not the right list for this, 1. Apologies, and 2. Where is the right place
for this inquiry?)

[1] https://lwn.net/Articles/710533/
[2] https://lwn.net/Articles/710535/
[3] https://wiki.linuxfoundation.org/networking/iproute2
