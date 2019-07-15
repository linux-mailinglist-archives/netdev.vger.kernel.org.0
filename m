Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE29E69F90
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 01:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732586AbfGOXiY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 19:38:24 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:40265 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730429AbfGOXiY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 19:38:24 -0400
Received: by mail-pf1-f193.google.com with SMTP id p184so8143490pfp.7
        for <netdev@vger.kernel.org>; Mon, 15 Jul 2019 16:38:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Wb9AhnVU2nGcM7ZtKetQrB0t0U0Isi9C+wVTlQwcOjs=;
        b=ERA2QWrlK8htpNT2sTGmJa4xRpoZhpbL/dAne30J25OEBNaJLv4qw2jy9V4FTZduEZ
         rmomZvvs4WshHUVSLspIcP3xBOJpEZbyjGlLBoJk0X6Y9b27ATI9QNYstO9Ffw/05kTS
         AqPuiQ/d1Xrqw05vol46mPxMN5ngRs+cQUECsg6ZlGvBWAHjDZM6o8nStUn3rNvpsK/5
         5vPGldwvjreWebTm/JLs4k7XUthgC2Thn3azHBaK8xXBGfWf0nhfGayL5FXzrAycMwWM
         swlKhjoI/fXy+SocqyjBrIA0IMUSFgD+E9x9ODxjzbDgK/2klisBXJfcijCpXK8mTy6o
         CIRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Wb9AhnVU2nGcM7ZtKetQrB0t0U0Isi9C+wVTlQwcOjs=;
        b=KN4856LJCmSu4PPw+rnLVIzvObeIq4Uh6t5TqHFFkoJlWS4YsM14Z7EzG7vRUXzJ4C
         eKAbVnn4t4GJFcJM6ne+SMiTHqSi6gK3BhNnq9GL57YwCoQIzIWZUgtsXIF72k3CCBs5
         QUaWwFw+WLvLqyfmbvi4hcAswYUdKHHiqsN9YiloLlkyInIdaQXdGNuGkcv0l6C//cLd
         EuHTi+0g0L4ikBHkmiUPEtLPs/SgwhLh1RJWjEDHwUprsPrtZobo7geXwY4+B/FX/UH8
         RMlYyg5bzEG6wslMv9wxCWe+kL8FbICRSeNS0UtNuNKdbPq3kPJC4254ipNPc9ePukvW
         DqMQ==
X-Gm-Message-State: APjAAAX0N9ylz3huUM1C0ctHprzc1RVWjwWePzFOmUAaRK9GcSjrR/k3
        ENBvCvTHINy+Xp7TFCnXjGU=
X-Google-Smtp-Source: APXvYqyOWEajqHEeDQkjoeanYncJmvRr5GJ160W2DECeYjuVO2KIrwOQjpNL243BxnmxNuda9nogYw==
X-Received: by 2002:a63:2259:: with SMTP id t25mr27709190pgm.298.1563233903664;
        Mon, 15 Jul 2019 16:38:23 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id s7sm16217326pjn.28.2019.07.15.16.38.23
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 15 Jul 2019 16:38:23 -0700 (PDT)
Date:   Mon, 15 Jul 2019 16:38:22 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Vedang Patel <vedang.patel@intel.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, vinicius.gomes@intel.com,
        leandro.maciel.dorileo@intel.com, jakub.kicinski@netronome.com,
        m-karicheri2@ti.com, dsahern@gmail.com
Subject: Re: [PATCH iproute2 net-next v3 3/5] taprio: add support for
 setting txtime_delay.
Message-ID: <20190715163822.32596123@hermes.lan>
In-Reply-To: <1563231104-19912-3-git-send-email-vedang.patel@intel.com>
References: <1563231104-19912-1-git-send-email-vedang.patel@intel.com>
        <1563231104-19912-3-git-send-email-vedang.patel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 15 Jul 2019 15:51:42 -0700
Vedang Patel <vedang.patel@intel.com> wrote:

> +			if (get_s32(&txtime_delay, *argv, 0)) {

Is txtime_delay of a negative value meaningful?
