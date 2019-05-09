Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B61B193E3
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 22:58:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbfEIU6i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 16:58:38 -0400
Received: from secvs02.rockwellcollins.com ([205.175.225.241]:7407 "EHLO
        secvs02.rockwellcollins.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726608AbfEIU6i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 16:58:38 -0400
X-RC-All-From: , 205.175.225.60, No hostname, robert.mccabe@rockwellcollins.com,
 Robert McCabe <robert.mccabe@rockwellcollins.com>, , 
X-RC-Attachments: , ,
X-RC-RemoteIP: 205.175.225.60
X-RC-RemoteHost: No hostname
X-RC-IP-Hostname: secip02.rockwellcollins.com
X-RC-IP-MID: 254609320
X-RC-IP-Group: GOOGLE_RELAYED
X-RC-IP-Policy: $GOOGLE_RELAYED
X-RC-IP-SBRS: None
Received: from unknown (HELO mail-pf1-f197.google.com) ([205.175.225.60])
  by secvs02.rockwellcollins.com with ESMTP/TLS/AES128-GCM-SHA256; 09 May 2019 15:58:36 -0500
Received: by mail-pf1-f197.google.com with SMTP id d12so2413813pfn.9
        for <netdev@vger.kernel.org>; Thu, 09 May 2019 13:58:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=kdqvw3lnIhsTo+5XUZxKdf6h6/0yeA/L3eB2ko4rZ+8=;
        b=SY4JnBz39pxYTRvfy/MoCEBZUvOdIga24JcC4kDeB4ezYsU4F7zQSeaaY0CgDBtn9i
         Xp+q6XgrE7xfHE3pRfXyKq90q/oYgIv9dgb574n5iyzOB1UgfyJ6AY70+K0Ca+zYNhH0
         TxAED9bwfFYBx+blrCh/Ht6d/EZA2KVRvJBTkcKO1hG3tNXHIV26b9i+0tpNfLN/lBJp
         HAsd2qDbJwPQ95Xb9bbtN/mJnYqFfyOK69TzfdqfOW5H+uQ3oNl32xnZ24LP2RIAotAy
         F+JZgaCs/9Nx1WgXWOjJQOAQl+H+m4DFD/x94yJP1OKu/tYttuIta0Hr0JSSJ6pKzZpy
         Qfcw==
X-Gm-Message-State: APjAAAWnwsFg6d0BRKAM1h1LcSRD4mEASM5UNqdVeetfEh9hUzYoRwo+
        vW/tsRNgzpsQm1WNbeL/kZKm5vWhfF5wAtgufdLHtqscwNeY6LQRfdOgS5RIVaI0/1f4r2NN4tG
        1hRBNUZz0K0jiH5kqjSoDa9fvUx59Y4IVPOWD/sttX0BnkCxmJq0=
X-Received: by 2002:a63:5c1c:: with SMTP id q28mr8439460pgb.45.1557435516192;
        Thu, 09 May 2019 13:58:36 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwmz0RTiuLcP6RfmhLPCBp6PntWMBNrhZ8N5GdQdfzhXibIkASu44ueB1bHvIfxg7sWcXRx/kiUb3st9IPAz+o=
X-Received: by 2002:a63:5c1c:: with SMTP id q28mr8439419pgb.45.1557435515652;
 Thu, 09 May 2019 13:58:35 -0700 (PDT)
MIME-Version: 1.0
From:   Robert McCabe <robert.mccabe@rockwellcollins.com>
Date:   Thu, 9 May 2019 15:58:24 -0500
Message-ID: <CAA0ESdrrSrm+eemJ4V31HcUDWYYKWCX6f5D42VpBxpKbnLcPZA@mail.gmail.com>
Subject: Question about setting custom STAB
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Awhile ago I submitted this iproute2 patch:
https://patchwork.ozlabs.org/patch/784165/

And the corresponding kernel patch:
https://patchwork.ozlabs.org/patch/783696/

To allow the setting of arbitrary qdisc size table so that the packet
scheduler code in __qdisc_calculate_pkt_len charges the correct
bandwidth per my custom link layer.  These patches were not applied
because the reviewers didn't like that I added another enumeration to
the kernel's UAPI:  TC_LINKLAYER_CUSTOM.

My question is: why is the setting of the STAB not exposed to
userspace applications?  This seems to be a powerful feature that is
more generic than hard-coding the STABs for TC_LINKLAYER_ETHERNET and
TC_LINK_LAYER_ATM.  Or maybe I'm missing something and there is
mechanism to do this without my iproute2 patch?
