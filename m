Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 188BB10B2F6
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 17:09:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbfK0QJB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 11:09:01 -0500
Received: from mail-pf1-f171.google.com ([209.85.210.171]:33397 "EHLO
        mail-pf1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726593AbfK0QJB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 11:09:01 -0500
Received: by mail-pf1-f171.google.com with SMTP id y206so2619570pfb.0
        for <netdev@vger.kernel.org>; Wed, 27 Nov 2019 08:08:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=PSazCWrzWwutXjlILzEqtU6aL1uS/GzVDtw5TFilKHA=;
        b=fMqkqJTrldxWb9xVLjP2WaKGloj0rCWfweNiT1RNvcxp40gbSOd+TIWLxp8jRMQkDI
         n+X4HR9ECm4+FyPJcZdTrjcHiyTlACM3D90YiJcdjaNJ4ctMnALW8YJZYwwTUfUfJJib
         nM19Duc42d86jhlB3F6TeKjYQv0GonwaJZrCrnnjg4HfN2N8tjZ9grERgwAlIkUYGPTL
         NboggmlaNLT345dG/7ZZ7t+Q0bsZczykjyYe17dEy8sXvxUDzIwmpVbn5fCvXiw5u2XM
         omjbNwIunh/hQoGlOQdCwWhN9ZwjOeHBSL+SxKqzQzk1HqA00V1fYlxVtvQ9zIQd1avc
         dI/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=PSazCWrzWwutXjlILzEqtU6aL1uS/GzVDtw5TFilKHA=;
        b=alM3ezJdkRLF++TfaaN/GN39K7AShd6IGmzzUwl2ZEcfnM5hDJlZ1+uN9zzmd0d6yH
         olA9FX84lPnQJooz78Qk8QT3Is908iIuitgreQIA8gS5J/PiclRzKxXh/XPBUw9jPqBG
         kiZ562h2UbvQEGTqJ1G25lUhq2eTyrSv+tT1sF4QBz0z4Tf2MLu81w4Xhm1hA5mlPt3I
         vvU06bfZa0jYAfRoMY9bnYiqjcRGTBaReweY+bbzuSuF2sJEHDJN/EMTii13Zsm+5Ybm
         luLhW13diKeMo7l1XhWRrOo5hPuiNy19UqABC14kBf494UWdRHOLSl1003iKRBMf1cyg
         Z3mw==
X-Gm-Message-State: APjAAAWBUIkYpoWfui06fpebl3+QYZgAE+hKbuoDSzgp/cKNy/81k2a9
        BfYizfL3zcu033Be2Wg30Nb+m8uB3OXdMQ==
X-Google-Smtp-Source: APXvYqxBXkT4U4184gshT8EL4vRhfkNW7ZHyPH6NqVbSrh7oTOb/Bu1FPuo9jZTGWTXhBM1hSc7LMQ==
X-Received: by 2002:a62:1488:: with SMTP id 130mr182778pfu.238.1574870938407;
        Wed, 27 Nov 2019 08:08:58 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id k10sm7138619pjs.31.2019.11.27.08.08.57
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Nov 2019 08:08:58 -0800 (PST)
Date:   Wed, 27 Nov 2019 08:08:50 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 205681] New: recvmg is overwriting the buffer passed in
 msg_name by exceeding msg_namelen
Message-ID: <20191127080850.2707eef0@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Wed, 27 Nov 2019 06:36:50 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 205681] New: recvmg is overwriting the buffer passed in msg_name by exceeding msg_namelen


https://bugzilla.kernel.org/show_bug.cgi?id=205681

            Bug ID: 205681
           Summary: recvmg is overwriting the buffer passed in msg_name by
                    exceeding msg_namelen
           Product: Networking
           Version: 2.5
    Kernel Version: 5.4,4.0,3.0,2.6
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: IPV4
          Assignee: stephen@networkplumber.org
          Reporter: sudheendrasp@gmail.com
        Regression: No

if (msg->msg_name) {
        struct sockaddr_rxrpc *srx = msg->msg_name;
        size_t len = sizeof(call->peer->srx);

        memcpy(msg->msg_name, &call->peer->srx, len);
        srx->srx_service = call->service_id;
        msg->msg_namelen = len;
    }


As seen, recvmsg is doing memcpy of len which can be greater than msg_namelen
passed.

-- 
You are receiving this mail because:
You are the assignee for the bug.
