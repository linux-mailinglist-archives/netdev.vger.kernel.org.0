Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AEF33AFA30
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 02:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbhFVAec (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 20:34:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbhFVAeb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 20:34:31 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CA6EC061574
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 17:32:15 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id f30so33145677lfj.1
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 17:32:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hd0dx4kwbwguz5MDgTGLn2DU0/AW4pps+wsg+1tpiws=;
        b=WMd/24FwiGon7MHUQ25zHmPwy3feZq8UBBAhVKmYkYTqSSoVgNu8SG2QKzlrcMuhaQ
         2vCS+qEqMFYrzndwXQxIDTkbqePPHz4Pb+960zF1BMfYK+8EI/1EZAj4LqJsjifI2PHr
         lb0WPvitr8VUgCvJdtPDRABNsZdWGOrTq1hGy/rG2JiVCIpo2oh1BQjEUwDaT5uW9CqP
         skNeLvPgoLAXyNPWMHFgHRAHEJSzT4Y2kJC0K9U217N4QpTl4WE6QMZgL5x7zs0QFRZF
         IHJgy55qkGHRQFS7SEFVuEDM2/VwnFW74gOKEpLftGN/WkKRMk3lOEk4vnoOazOEMssp
         /RRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hd0dx4kwbwguz5MDgTGLn2DU0/AW4pps+wsg+1tpiws=;
        b=V7rZEoM9i20ZO+fWjHlsEipz37k8yltMGmdeAiRaOHLlV/BndLlUvfSE8cBbY5pjZ+
         rGuDtULPAHcqTGdMFb28KmuwP9a8Y6EY/qNPsxYCqPEmSd+OjplPpTVNytBG2s+yveB1
         Zc3hoEzfUP4AehTTKPOy+m4OE6WrjqJ2AlQD/x7a7PkuCucAmHwdfUWVRMH8dOgXPDiy
         xdU5+O3lxxumgmFrEmo+QWE1zQfz74C2UIRzPzkFkoGS3vkzQ50S2UPdnvIinX3TLj9/
         ypEZqNItNuSLpQFm90dJzugHLTeVpPN76FV28lOHGcoSDyN6pzK+3qsPQ1Kb1B8oF11Q
         zwiA==
X-Gm-Message-State: AOAM530vbaDcH+vnSLhn24ljlG1RJe7P6SG/8sqYaxuqJLllUujJkJel
        fW9Z++hG0oRHRVdpSkLy6gY=
X-Google-Smtp-Source: ABdhPJyrbhYDSvS4BdvMAZni8UOfbe7yhe6U/vh4BsooFlZVpcGmSB4O/a6nAbb5wZ5BUMUIAl73YA==
X-Received: by 2002:a05:6512:3c9e:: with SMTP id h30mr689091lfv.183.1624321933638;
        Mon, 21 Jun 2021 17:32:13 -0700 (PDT)
Received: from rsa-laptop.internal.lan ([217.25.229.52])
        by smtp.gmail.com with ESMTPSA id br36sm404767lfb.296.2021.06.21.17.32.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 17:32:13 -0700 (PDT)
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
To:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH iproute2-next 0/2] ip: wwan links management support
Date:   Tue, 22 Jun 2021 03:32:08 +0300
Message-Id: <20210622003210.22765-1-ryazanov.s.a@gmail.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This short series introduces support for WWAN links  support.

First patch adds support for new common attributes: parent device name
and parent device bus name. The former attribute required to create a
new WWAN link. Finally, the second patch introduces support for a new
'wwan' link type.

Changelong:
  RFC -> v1
    * drop the kernel headers update patch
    * add a parent device bus attribute support
    * shorten the 'parentdev-name' parameter to just 'parentdev'

Sergey Ryazanov (2):
  iplink: add support for parent device
  iplink: support for WWAN devices

 ip/Makefile      |  2 +-
 ip/ipaddress.c   | 14 ++++++++++
 ip/iplink.c      |  9 ++++--
 ip/iplink_wwan.c | 72 ++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 94 insertions(+), 3 deletions(-)
 create mode 100644 ip/iplink_wwan.c

-- 
2.26.3

