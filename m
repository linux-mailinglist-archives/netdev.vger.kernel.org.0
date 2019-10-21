Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A30DDF8C6
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 01:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730391AbfJUXsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 19:48:04 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:45061 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730065AbfJUXsE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 19:48:04 -0400
Received: by mail-pl1-f195.google.com with SMTP id y24so3465889plr.12
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 16:48:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9XCHHIYdGEz/iduoQMrkg6XrAAs4/fPqpxInrhsRQTc=;
        b=AsXaKTBMvPoB57G00xogNarjhO5uHd02+fbjRNNi/pvsx44OIiES6hJhV5OX4dG+xO
         I0+hCT3n05qmYQECztxZMX9UfLRt5ZuRs/m0ZeEMAIiDDPHisvQZijAG8oA5+sA+oPO2
         liHGhVbDnirt0FZxBgzQ90yb9S4yq1rXNnXhTX2D/aopnu7h+wDS+dya/y/YJKxeJW+x
         a+NrjYg20Mk1i3H44YJ8lx/z4EpHI7zPOsObODCu80qOKxOSnrl4hdZjpJSPm739aakb
         kbT3lw3Kt2bV98KuK65VA8k2d6hm0XeqpiSj8fGiHG6kP1FOWqxHz5pf+dNwbKaPsAza
         e87g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9XCHHIYdGEz/iduoQMrkg6XrAAs4/fPqpxInrhsRQTc=;
        b=ti8j1yIzqBg/57mEOJ7wjrmeX1WlHt3YDGS3U6gGICYYsB5S644M6cGeYfv1i1yn4y
         tYXLRTzjWVGF92p59HqXJmvHVx/luy/VAb8KocW2Evns00r+I7WiaMJMNQW+hoz1sE6Y
         ISJQvPmmyV3q3G9wP19FuwaUa4mkq9NoHp520GAxbjAydVbJvXpZxxCx5f8efBZW6KQx
         bEbmbZkqkSmPMajCSp6y6MupJH5XAtEH2cVJBDswhVNXLEq9X9QAF7Xz9vS3c6/IPP46
         elWKytewoF3N4d3qAFGdEgafjO0+/8Kw0C3X0R/uQ1TLQP02LEkWf9HKbNT1hEMYxvkk
         wgWw==
X-Gm-Message-State: APjAAAXm6UacNu9CyLkL3IontoglqATjkKtuBL/966VpXZ+fNNEzPz8S
        Gjzy5ScI390bwo7eAhwYscqHxQ==
X-Google-Smtp-Source: APXvYqyQGODB5cltucNLyokjkza0CmykHVvs3AwZsSUXE/t+aZ7i5+3oXByvUzAU+Cm/WqMWrIJrwQ==
X-Received: by 2002:a17:902:8bc7:: with SMTP id r7mr574563plo.333.1571701683418;
        Mon, 21 Oct 2019 16:48:03 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id dw19sm16306885pjb.27.2019.10.21.16.48.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2019 16:48:03 -0700 (PDT)
Date:   Mon, 21 Oct 2019 16:47:56 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Dave Taht <dave.taht@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2-next] Add tc-BPF example for a TCP pure ack
 recognizer
Message-ID: <20191021164756.33d97954@hermes.lan>
In-Reply-To: <1525199561-9302-1-git-send-email-dave.taht@gmail.com>
References: <1525199561-9302-1-git-send-email-dave.taht@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  1 May 2018 11:32:41 -0700
Dave Taht <dave.taht@gmail.com> wrote:

> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright 2017 Google Inc.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version 2
> + * of the License, or (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
> + * 02110-1301, USA.
> + */
> +

SPDX is enough don't add boilerplate.
