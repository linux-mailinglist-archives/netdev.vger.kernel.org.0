Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB491FFDD9
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 00:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731899AbgFRWRG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 18:17:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731771AbgFRWRF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 18:17:05 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5AB9C06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 15:17:05 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id i4so3391444pjd.0
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 15:17:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7zVORohIVq8AyxCXbERjyhWI6QwOwI9f/EozLATge6M=;
        b=duQkJlKRkLXmnAgnZc8GGFIlREHc3NZRPdAoDmYIWJrYMkxw3GAdvLsc8T4qokjHaZ
         rQAPotNRkjKq+C/ObjIkzA1WX0RdpLhihPhVO7DOvwhE8h+UpmNyrzJr6juYk4+Lmy77
         cNhIOrm0tljHBcEfcEFXyJvmrmdvm1u5BnyOMxgqtZYyxPUn5M1f2g8d4BmgNc+Kx/sH
         KlRL8x2qgFqo3CvlK7bdhwxv77PqHrpAIx9MxqxDLyfyG/mH/KpL753Q6tCsxkTp4f5t
         qWbjyDqS+euLscwc9yYCSk//nFNZ14JMskuRn75w+vZOV7klhyLuKPJP+OBe1RxmbiF8
         E+5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7zVORohIVq8AyxCXbERjyhWI6QwOwI9f/EozLATge6M=;
        b=VqsNTDtPcGQz83tHXJ/U0iigZrYU73ISlctwgyD3OMeKOVkOx/ZKI9BqBC69TTpLjD
         SZ0ydzwkl3C2EFDCqAbmw4BTUvouRpMniVinBFvdy7Y7gZfoqo+b2OTp/3xyqnhWhVZ1
         GClppHUKQ++vuQdi5XbUvOU1fvuPDuc2pPcIO416AhGq1y3dH13l5LlZRqpG7BH5ECLg
         VGd+AwMobxl7bkbAyPHKfZzXcXtG6gfmlSRSFKN7i3s39BXE9LfLM7CxY1bNs5EILq9p
         unH8vP2ub98JH/v6SPPowPzIMR0aOhLMEToK2b0zxDa6HCE/DXuJOtVdt9Q2A3B0pfex
         B4mw==
X-Gm-Message-State: AOAM530+Wo1CwzxmKPURdTg9YdKRMZVy8C4+iB2CfnLZvBafYkSNeQDy
        mZ4Y+ztDKf3ujx/4XfC3N4v3DA==
X-Google-Smtp-Source: ABdhPJy6DaYueRUJeQDkBnKuS13KZ+1uArvn/Uqp5mgezscr3+srZIRrjkPfdeN8jLfIiy/d0ATEsg==
X-Received: by 2002:a17:90b:4c0b:: with SMTP id na11mr485702pjb.176.1592518625423;
        Thu, 18 Jun 2020 15:17:05 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id i20sm3920907pfd.81.2020.06.18.15.17.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2020 15:17:05 -0700 (PDT)
Date:   Thu, 18 Jun 2020 15:17:02 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Anton Danilov <littlesmilingcloud@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v2] tc: qdisc: filter qdisc's by parent/handle
 specification
Message-ID: <20200618151702.24c33261@hermes.lan>
In-Reply-To: <20200616063902.15605-1-littlesmilingcloud@gmail.com>
References: <20200616063902.15605-1-littlesmilingcloud@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Jun 2020 09:39:02 +0300
Anton Danilov <littlesmilingcloud@gmail.com> wrote:

> +				fprintf(stderr,
> +					"only one of parent/handle/root/ingress can be specified\n");
> +				arg_error = true;
> +				break;

The concept is good, but it could be simplified.

You are repeating same error message several places and it is not
necessary to continue parsing after one bad argument.

See what invarg() does.

