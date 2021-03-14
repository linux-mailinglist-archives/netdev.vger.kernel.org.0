Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81DC533A206
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 01:16:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234296AbhCNAPm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Mar 2021 19:15:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231205AbhCNAP3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Mar 2021 19:15:29 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5EF6C061574
        for <netdev@vger.kernel.org>; Sat, 13 Mar 2021 16:15:29 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id f2-20020a17090a4a82b02900c67bf8dc69so12533217pjh.1
        for <netdev@vger.kernel.org>; Sat, 13 Mar 2021 16:15:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rzb8ufM0uFjmHNeg+3ut+9VYZzO9jdPHQvlhTBFV0Rc=;
        b=HfPvWjD5UCCqDdmSaTGzsfHIdUPYF4Ax03RBRWRIH/2jPkEfsWzy9Amsf1NOIMrYhl
         fw8VPVzPnzyW/UBwEqUXz82PbD7dWXChlpa+DRkb/4GRaFAwJQ5OEkpqsqUymY2rV5cr
         QeBzDxP5uHLIt2hw2jDKSOVCqk7lfpA6wukcWkDG0Ejkr0NdKHkWJUi6tDxoVNl3nE+2
         cTbir4Gj3dJhDz22NUyKgnWweYhNrg0k9lUMOMXcx4wZYX8vT1zFlisWAFMQLOrTsWw4
         zKsJHM/uN67Re6x1k2uGaOzDoMqccfXB8o1zusghApaVjne0rDTv4R8f9zmrzl5IZ4kx
         IPvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rzb8ufM0uFjmHNeg+3ut+9VYZzO9jdPHQvlhTBFV0Rc=;
        b=YsLzXZ1u2Nhz6LSiATaUaLPn6ZgFhKF0mcsx3RJWb05O1k5IA7YL6sIwgOjrj+uz6C
         WMSnam+X+5L4jdBzs9R6iIrWWgLAYsbbYcGLiLkbClaGQ2LvPHHAhkGWbjVjPShQG/7r
         I93ADemkgn7ZUljFCcKmAeTgPc+mHExVHHDcEYTlDfDkqFhQTb4x9KiXFzrDssQb8mf1
         IHaOGr6kz5+AjB/5AYkpqv2+9xU/S/z01rxIoOFO09yXj5aODziOV49yi864hMEg4PQH
         6eXM+fzzOpUoErDV1o84wP7lQaWacmt5HwwyPwWbsYIV/DxbCNUAgXmjHAswF3NUSsDn
         FuEA==
X-Gm-Message-State: AOAM5305kJUNqv1NEXavuFV7yfPG/Z+TgDVxzadiwTCI+k0Kd7d4EQ2O
        UYDrD8c6r57MdY5thMBOJAhVTA==
X-Google-Smtp-Source: ABdhPJxNwHyOEwLlNLaJbUtlngbWkIpGX1TVOBbD/JhKHAKIED12UdUwFZ35HF+o7YybQX2zC6vgiQ==
X-Received: by 2002:a17:90b:4b87:: with SMTP id lr7mr5429935pjb.5.1615680929054;
        Sat, 13 Mar 2021 16:15:29 -0800 (PST)
Received: from hermes.local (76-14-218-44.or.wavecable.com. [76.14.218.44])
        by smtp.gmail.com with ESMTPSA id y2sm8302048pgf.7.2021.03.13.16.15.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Mar 2021 16:15:28 -0800 (PST)
Date:   Sat, 13 Mar 2021 16:15:20 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     ishaangandhi <ishaangandhi@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, willemb@google.com
Subject: Re: [PATCH v2] icmp: support rfc5837
Message-ID: <20210313161520.19cee7e0@hermes.local>
In-Reply-To: <20210313063535.38608-1-ishaangandhi@gmail.com>
References: <20210313063535.38608-1-ishaangandhi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 12 Mar 2021 22:35:35 -0800
ishaangandhi <ishaangandhi@gmail.com> wrote:

> +	// Always add if_index to the IIO

The kernel networking code has not used C++ style comments
Checkpatch used to complain about it.
