Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 029CE399960
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 06:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbhFCExA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 00:53:00 -0400
Received: from mail-lf1-f46.google.com ([209.85.167.46]:38688 "EHLO
        mail-lf1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbhFCEw7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 00:52:59 -0400
Received: by mail-lf1-f46.google.com with SMTP id r5so6871645lfr.5;
        Wed, 02 Jun 2021 21:51:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=t/8TbaESSlR/r92D3SJfkoGTMiMWS8sVV3O+Sl3PY6Q=;
        b=J1dah+fUnZwM6+WocWWGc9Hv1LsTI6Am2EG2aTh2Zy+bAs8ElInVLnMU8HcU/Hk6XX
         StuwARSRpgLUHbdWPSGXnD6O71DHM1f7UrBWdl6Xi7ji8J+4FrgmDiwHqdgUYYHARctt
         Yw7/F6LJEA/54bwagcg+jkjFHSwioIbe337k57CMpgcA3IHyQcT26ruJUfITP90uVZit
         OP8CO2/6psWlzFBkuIZlJaVuRGWEcS6OF4qAnfrJB1qRrOD4DczU9kdoLM0C+CpOiZ25
         enVGirQyEdQIQqu5X1RnPqUOigM/8di6HX8yfZopCGYA937TziA0x9sJP5Tbt74lQBAN
         aMlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=t/8TbaESSlR/r92D3SJfkoGTMiMWS8sVV3O+Sl3PY6Q=;
        b=Qura1W3w9y0vK+DjuSD1uUiqm7pwEivp22RKOPiqlW78ZiwRtbRwchQa3DW/RoWdID
         4e64wkW0mqhljB9i8HzBj79QOI1dGDHb2fDzzYs8smpLfQiFdNNoLNk2tTMXOBqMNf0y
         guDmlbru7ZNwWGC8aGLFqZZwbn13ABAywTXiGtNiDMLcCOgoQa6fEpRSbgXuFj9yf9Nm
         K8Lxe/XMal8R+gQWxxPFZoiBpEbmK6GGg2eezewcC6dlvnU9pkSuXbzPR2i+w1M7Uwje
         M9ai62ko7cHKGqGv5CteKCafM9m1yM0XyS7MX+NxpDSOKgLAeXaH0jnyBEm5NXQaIC/s
         5YEQ==
X-Gm-Message-State: AOAM532F7hwDOTMJUOoxdTuZODKGnebTSkb85L7pN8Ekai9hq1MwRggR
        BlMiLuibBqTFW7bWNHMfKrc=
X-Google-Smtp-Source: ABdhPJw8MYPOanoqEDzNOATJKx0i6oyzCl0M0DQCSpAeXn5VJlqoGIrxUe4d9TaYseNb8SOYnURxXw==
X-Received: by 2002:a05:6512:511:: with SMTP id o17mr4279286lfb.202.1622695803308;
        Wed, 02 Jun 2021 21:50:03 -0700 (PDT)
Received: from rsa-laptop.internal.lan ([217.25.229.52])
        by smtp.gmail.com with ESMTPSA id z2sm191328lfe.229.2021.06.02.21.50.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 21:50:02 -0700 (PDT)
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        Loic Poulain <loic.poulain@linaro.org>
Cc:     M Chetan Kumar <m.chetan.kumar@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [RFC 0/6] WWAN netdev creation framework tweaks
Date:   Thu,  3 Jun 2021 07:49:48 +0300
Message-Id: <20210603044954.8091-1-ryazanov.s.a@gmail.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a follow-up series to the proposed generic WWAN interface
creation framework [1].

The first two patches are small fixes for issues that were spotted
during the original code testing. The 3rd patch completes my suggestion
to make the parent device attribute (IFLA_PARENT_DEV_NAME) generic by
revealing the netdev parent device to userspace using this attribute.
The 4th patch was added to make it easier to test iproute2 changes, in
fact it just copies the definitions from the kernel headers to iproute2.
Finally, 5th and 6th patches provide an example of userspace support for
WWAN links management.

At the moment I do not have access to any WWAN hardware, so the code was
only lightly tested at runtime.

1. https://lore.kernel.org/netdev/20210602082840.85828-1-johannes@sipsolutions.net
