Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A35B626A24
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 20:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729005AbfEVSwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 14:52:32 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:39304 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728533AbfEVSwb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 14:52:31 -0400
Received: by mail-pf1-f193.google.com with SMTP id z26so1796511pfg.6
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 11:52:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DBIfivGfGH9123bC0datQ+AiiQHJvh8OMmix64lJxU4=;
        b=VbuFffG6zinPIbcDF4Q0Txre1g/BQAo6xvFnM3VE7maWZ4o7E3D6mmdirELmevpLcW
         lr7vr8IQcONz7QEXzHxQH/yKfGjMR2aSfbSbwUvZjdlq1kansEgNmnZ92HawxM+/+6rk
         kqal6tpvZRg6b8Gr6p/PQvnLZghh6H4q738gOihEgK/B15Z66RflukCzT2zR3S0xUUWq
         FbjMf3A/gQIygQJK5btUXRMjI7iOiVV/wgVDyP/m0yrwOmW19IDvfr6yth3wq2E1CTeK
         x1Llpka2Tyd29EPtLCUS81+XPMLWJ43J4dw+R+9h0qelHb+581aYKsjBmBcfyxwutGWY
         9ilw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DBIfivGfGH9123bC0datQ+AiiQHJvh8OMmix64lJxU4=;
        b=T5bMTItUduRKf0M1si0SSptF8D7IXPZN1lvgnfRvIoKuHkWTcsW7CnWxNHKCKUk34v
         s7Ls/B+/+Uh6tKkciDzRdJSVYVwMrt2pCaYWAZ6Th4E2NASpZZejGk3UijVFj+oF0O0k
         7wGEiEY+IR4PtWoVoTmCe9qMunYBAV4GBRa43Chn4qy8pQsnClJ0gM+hVHys1uty1ycU
         XSAq2V9VE9Aj0/seyVr6Fh5kQYZ4pC37uDQWQAVYWRF3si8L89HJ56IPbKb197IJxrM8
         Q+NhGzveJ10msFrBkCwQy0TLBiNi/XMtNG1a6iDyOlrDZmG5VECGqXWHb52TxFOpMcx0
         PSiQ==
X-Gm-Message-State: APjAAAXLALVFS5IFXUE7uYcb9KhVIFQKWSfdEED5GaYS04409Nn68tJI
        DWSpdqcFe4tgtjHLpDUIxVgRuOSEYV0=
X-Google-Smtp-Source: APXvYqyik5cEmjtHPih1PDNJU5SbRZVDKnbweVTVaLzu6Y6RplQYOuB8c46Wn7tl+QdMxBSa3KPZdg==
X-Received: by 2002:a63:da12:: with SMTP id c18mr4255202pgh.268.1558551151078;
        Wed, 22 May 2019 11:52:31 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id p90sm9327155pfa.18.2019.05.22.11.52.30
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 22 May 2019 11:52:30 -0700 (PDT)
Date:   Wed, 22 May 2019 11:52:23 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@mellanox.com>,
        Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH iproute2 v2] m_mirred: don't bail if the control action
 is missing
Message-ID: <20190522115223.41833661@hermes.lan>
In-Reply-To: <fb92be6e671450d181f552c883feae849f840283.1558345901.git.pabeni@redhat.com>
References: <fb92be6e671450d181f552c883feae849f840283.1558345901.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 May 2019 11:56:52 +0200
Paolo Abeni <pabeni@redhat.com> wrote:

> The mirred act admits an optional control action, defaulting
> to TC_ACT_PIPE. The parsing code currently emits an error message
> if the control action is not provided on the command line, even
> if the command itself completes with no error.
> 
> This change shuts down the error message, using the appropriate
> parsing helper.
> 
> Fixes: e67aba559581 ("tc: actions: add helpers to parse and print control actions")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Applied
