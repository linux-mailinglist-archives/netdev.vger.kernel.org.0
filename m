Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D95F7C86C6
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 12:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727217AbfJBK4x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 06:56:53 -0400
Received: from mail-wr1-f46.google.com ([209.85.221.46]:42340 "EHLO
        mail-wr1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726694AbfJBK4x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 06:56:53 -0400
Received: by mail-wr1-f46.google.com with SMTP id n14so19090363wrw.9
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 03:56:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sd/l9hpjnTZdbWy0dGydOIHjXQmEJuExYaVRZvioKAo=;
        b=Hx7gbu+zOV7vaGhkO7Id4SP/Y4LDQYJn7DcoP3Z4w3BWetIB6zLdP0GuZ/EnKjn34g
         sWrstH6O5ukSWHo+RQp6VaBB9oNuUOmFx7Dpr93xLfUjDiE+ttJcJgehGBPB7byAnp3t
         FILAp9joc806RBA+tpfwmC5YBHoKSlDgyax8jMRAQYN0mF+arR6ygC4m5ulHhUgQ/Zbp
         AkFAGj0MvBoqQpXRYRSSyJj4YwVARLYrBAVtXeg/oTsp/l0XMDORH6txue93XHAXn2xH
         yj6QmF5oxEp6jSLIRTqX+DGe9ySLjHwkNAsUslRJZOXDGL72C1v1wL1xw3ecJG+RLS5A
         syrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sd/l9hpjnTZdbWy0dGydOIHjXQmEJuExYaVRZvioKAo=;
        b=qfnkx919Z2ghLAXJDw9pWIYNnTTPmWugJWb+rBJUXuQ30dO2ZEnlzaKtgT52nD56al
         A6U6jWlw7O5KI5IvPAFy2CfqwpBMliMKbjv/mmK0NKM7uBOcrdi4WjfoOunCRlpBkiGq
         naVmuOD/nvzmwXBINBIrkNSzHSQ/DDMayQxnWkF8S5k2MSE+1UiJNpB5rNXeeXcbE3EQ
         IE5f7YG1JpPoLzYq0QGn+eT0W6rmpVesd1Q5eittblae80SpxVVXSTAlBl7MPqmnErQ2
         rjZzjdflsc85F2mGKzd4A1Qj+13OhyyaizHu2aR8GiyY7dHjzd6cBPZhzKNg5O/ANa9u
         yf0w==
X-Gm-Message-State: APjAAAWXSWqtE2brRsR85rY1YmzthuQoWbn+T1DASMYbWznkn3pErH4i
        7PS42OvpBLi64VA4hhsxCh6Xa+GzFxo=
X-Google-Smtp-Source: APXvYqwHj2327nWpBhNdPNS4o3szHiswc76hCzbY4aI4jetF2uFUXqV4P0/fmVTLChgLPGmObPsG5A==
X-Received: by 2002:adf:ef05:: with SMTP id e5mr2090343wro.127.1570013808928;
        Wed, 02 Oct 2019 03:56:48 -0700 (PDT)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id f18sm5883336wmh.43.2019.10.02.03.56.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2019 03:56:48 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com, dcbw@redhat.com,
        nikolay@cumulusnetworks.com, mkubecek@suse.cz, andrew@lunn.ch,
        parav@mellanox.com, saeedm@mellanox.com, f.fainelli@gmail.com,
        stephen@networkplumber.org, sd@queasysnail.net, sbrivio@redhat.com,
        pabeni@redhat.com, mlxsw@mellanox.com
Subject: [patch iproute2-next v2 0/2] ip: add support for alternative names
Date:   Wed,  2 Oct 2019 12:56:43 +0200
Message-Id: <20191002105645.30756-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

This patchset adds support for alternative names manipulation and usage.

Jiri Pirko (2):
  ip: add support for alternative name addition/deletion/list
  ip: allow to use alternative names as handle

 include/uapi/linux/if_link.h   |  2 +
 include/uapi/linux/rtnetlink.h |  7 +++
 include/utils.h                |  1 +
 ip/ipaddress.c                 | 20 +++++++-
 ip/iplink.c                    | 87 ++++++++++++++++++++++++++++++++--
 lib/ll_map.c                   | 41 +++++++++++++++-
 lib/utils.c                    | 19 ++++++--
 man/man8/ip-link.8.in          | 11 +++++
 8 files changed, 177 insertions(+), 11 deletions(-)

-- 
2.21.0

