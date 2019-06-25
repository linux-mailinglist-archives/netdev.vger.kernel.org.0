Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39C0955C28
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 01:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbfFYXVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 19:21:04 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:43584 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbfFYXVE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 19:21:04 -0400
Received: by mail-qt1-f195.google.com with SMTP id w17so351451qto.10
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 16:21:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=K8F+uLBUMjycLiQse+3Mll7gU+G0uQvg04hH99B0k6M=;
        b=tw4EGJegm/aw7zi5v63vcht9dDFEQfvwBcXltpQu42aV+t6daQjdh55rMwJhQSNjgB
         YIzqMw6m17u2I1qznOsVXB5TFhSgT1b/uNmxvPPYcyJwRFXNffr0M97fRQPcTKSq56oa
         mZ3I9onbIB0tfUkG33z3jhAvpqs34wjpJEFFd5bR2ED6U70p++jaPMVFpLAH8c2BzkHd
         ivWxG6I/MDJhDDlClvxr406ozWUK1djmkKpHgUHU1p5lRBzrM1iSB/Wqh9cwPNofaBcx
         ulT6bIJQygxeF4Y8FizHhRTdzwUwnjKdAlM9br0jflfzBja77UBOHnUSz1tbkX4Yjyft
         sKBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=K8F+uLBUMjycLiQse+3Mll7gU+G0uQvg04hH99B0k6M=;
        b=l9jGH2LX5vg9z8VrMWO9RWSqv09YFh/L0VZzfeBndhUbHHLgdmfXXY76vEqbq20ucj
         6kP2oNxgYlb9O27R4R6Pft/mTIz/pKwj3NXHc0Knjk3ui1ir3cFy/CGNrTye2zAAxHt7
         b+Mx6JIwKWT07cpZGTk+O+LXtT1/NBVS9YxO3R4EypX2khy8bb0qpdcg0K/VXZ41oazj
         bgtUpCtrZ38mt6BndHuKCzgv9IYwl7P/aDElQHllw5ykqeyB85802GMWNLf+/si0sFdq
         rxzF4SV8+r2mj3B5QizpA0COqfdHai/MDwM8HMXW7vekHPUTHVFou4xB6V224urhE75f
         qZTA==
X-Gm-Message-State: APjAAAW/Y9glfKBTZWgJ/BrStzjE+pQOA14FcAgZRPzwm0SMM0o0meih
        /+KTOXeA7fAFdh14I3vE4Yikmie3NXI=
X-Google-Smtp-Source: APXvYqyeF2VFboDlAigh3w7iUtmg9/rZX8uE1gtJy9RrEbrdI8Wiik8tZDJJ+DBKznRbkiGvWMCjBg==
X-Received: by 2002:a0c:9332:: with SMTP id d47mr790571qvd.222.1561504863351;
        Tue, 25 Jun 2019 16:21:03 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id k123sm8422474qkf.13.2019.06.25.16.21.02
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 16:21:03 -0700 (PDT)
Date:   Tue, 25 Jun 2019 16:21:00 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 08/18] ionic: Add notifyq support
Message-ID: <20190625162100.77a81054@cakuba.netronome.com>
In-Reply-To: <20190620202424.23215-9-snelson@pensando.io>
References: <20190620202424.23215-1-snelson@pensando.io>
        <20190620202424.23215-9-snelson@pensando.io>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Jun 2019 13:24:14 -0700, Shannon Nelson wrote:
> +	case EVENT_OPCODE_HEARTBEAT:
> +		netdev_info(netdev, "Notifyq EVENT_OPCODE_HEARTBEAT eid=%lld\n",
> +			    eid);
> +		break;

I wonder how often this gets sent and whether the info log level is
really necessary for a correctly working heartbeat?
