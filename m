Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6445A3A9D
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 17:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728178AbfH3PmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 11:42:11 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:45264 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727751AbfH3PmL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 11:42:11 -0400
Received: by mail-pf1-f196.google.com with SMTP id w26so4864513pfq.12;
        Fri, 30 Aug 2019 08:42:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=nz/4S1faYNn5ga9nu2L9rgyJ6VH4Vo5eCb4dHh7ASd0=;
        b=feCZi9AysGNFNdmbrv3UlPoWlxPyrVVaIWXPbelUWUy+OLm90AQm03AiptBFbPco57
         raLwJ1wC6nmlhdFUa0wi5EkQ2OSBLB3kAuSzAXZ4VY+iyCUOSVZmk6zF81near5WToaM
         Mfe7qBO9qIUo39cnGOVh+IV2fJXet9VUEtPyBMxbk5YlkLA1TL0160j4VAdF5+L1WBWW
         QVD3DYK1qg4ZD7vY7CVgwkBDwyXvM0AqHq+/pbpP1nTxMcAjs1AKnx85BZ++0lqKowxE
         0wqf5erbSMHClxag/A7+9PWwYAfGWIXEJ3My+xNL8+471mlip0pgttp4R643Bi1Y16sI
         VB0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=nz/4S1faYNn5ga9nu2L9rgyJ6VH4Vo5eCb4dHh7ASd0=;
        b=tSAO1FRN+Z/+SKtVhY+Mfetje9YM9SzJytEMDqmY7NXYlhZpGpkLNwmmB+H6qzFd3C
         xGCWT6zH8pPAZlv5TzJlZYmriSA45GihNUMrwj/EhMqcJG+aREijrZPCznC/k/jBtFvY
         vZWBrSsaxiRJey6tX3Zi0NCJmA+HToK9azRLOLCdZrEVbcAiyE6ovHt0JEJaJ6fQ6WsO
         MqWKnvS3xY/gsFEcDSKWEwmsKhZVnLDC87eJtFx0FOL2RtjVugWT1x6e0nUSzHY6stsf
         I8SnmA1t0WpgDKui9sGY8jiEYgRzDyBHofHljSIaraZSuPbkWbHAkzVRlW55/iWXt+Qi
         GguA==
X-Gm-Message-State: APjAAAW0D9pP6i3yw9Lh+EcvLnd256rcxOzjMd9jfV6oMu43BbPSEj4r
        XfCwzFmRuMWmmKh0QKB2o2s=
X-Google-Smtp-Source: APXvYqwrMFL8ZtVqMHspZc6WTRMYl7zk0ebMROhOMmI7eKfMdRPNn6Lb3rQGyzLuzKgmk+uSyAakxw==
X-Received: by 2002:a65:644b:: with SMTP id s11mr3197425pgv.305.1567179730421;
        Fri, 30 Aug 2019 08:42:10 -0700 (PDT)
Received: from [172.26.108.102] ([2620:10d:c090:180::7594])
        by smtp.gmail.com with ESMTPSA id z63sm6368612pfb.163.2019.08.30.08.42.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Aug 2019 08:42:09 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Kevin Laatz" <kevin.laatz@intel.com>
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        jakub.kicinski@netronome.com, saeedm@mellanox.com,
        maximmi@mellanox.com, stephen@networkplumber.org,
        bruce.richardson@intel.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH bpf-next v6 04/12] i40e: modify driver for handling
 offsets
Date:   Fri, 30 Aug 2019 08:42:08 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <34527E59-0A29-4904-B794-9592C5E818C1@gmail.com>
In-Reply-To: <20190827022531.15060-5-kevin.laatz@intel.com>
References: <20190822014427.49800-1-kevin.laatz@intel.com>
 <20190827022531.15060-1-kevin.laatz@intel.com>
 <20190827022531.15060-5-kevin.laatz@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 26 Aug 2019, at 19:25, Kevin Laatz wrote:

> With the addition of the unaligned chunks option, we need to make sure we
> handle the offsets accordingly based on the mode we are currently running
> in. This patch modifies the driver to appropriately mask the address for
> each case.
>
> Signed-off-by: Bruce Richardson <bruce.richardson@intel.com>
> Signed-off-by: Kevin Laatz <kevin.laatz@intel.com>
Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
