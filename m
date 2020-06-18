Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B403E1FDA00
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 02:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbgFRAAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 20:00:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726763AbgFRAAg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 20:00:36 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1C93C06174E;
        Wed, 17 Jun 2020 17:00:34 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id z2so4115386ilq.0;
        Wed, 17 Jun 2020 17:00:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=EYfYK1a47R4Pt+a65ABQenYJCxUYs6FFYcHNkdZ4LHk=;
        b=f8ssrKFm+JMXAuyBrvMcmX7XxC2WrLreer08MdvCFaUUPCHj4ayKUKPX+PXTxlPl3x
         A8k6V5OcWDN/DUcrwntt4GqeNlBz3A8uMtcFyUuBe5XNUceM8BegWgkiUp0PMxPc19SX
         NSUBiiTgwcCfhUWETvm6k30Zsm9pJdC5F+WwEnK3FSBc/s1rp0FyPMheuylh15Z1xWRu
         krWKv3cCmkuygak7YYT6rK7M9ck1cInUQZhtLgP/wg8OlUHMb8x9qmxR7yWGs7vzLlFM
         2HOsmfARZWYtbpn+ItITOCjCjq1VTywCkIj1gO0giMKCZlVQjZpPuBNkGa5smpBxulnK
         rktQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=EYfYK1a47R4Pt+a65ABQenYJCxUYs6FFYcHNkdZ4LHk=;
        b=AoR/bK+Xv2WBMFtZzH584oXE9m7/xumSj/NCM4Wvrl9mfkSyGD7uebZnd7CYYnxQEo
         Mgn6ZooXoZdEUXdp/vl3/443369qCxhlY0iDd7CvKB0kuDtocRVJ0eyDg81mGs2vzJ0U
         B3pQGDMONpA2mb8s8HMA7Vi+Z4m1caE3zoCJWdOw1pj9bGMb4G0SU5MGkx9O4ULCbvG/
         66ELKFCvH/0R7l/VHtRwJlZRMH2FicAxf2hMI2KU84mFZlNaJOtRKPczM5oZZBn7zJqr
         TQhHn3lWOns341D/OgScV7vC67dcoKhXk7mz/qbstpLVMGy6z+V7Un2Z9mf62NCVKqhb
         CJrw==
X-Gm-Message-State: AOAM530Wmkiords4Ri1GxRpjW4yMduhDX6s7i/ZOqKP+fY2Sg+/WKLBI
        1rclxJo5IytyxL9g2q+QmNM=
X-Google-Smtp-Source: ABdhPJxdACDLqjOC4VgXWlneV7BgrfUo+gtWGLmD1/LQVC0s2PhbOZQySD1Wv3c0e6qje5/iPOR40g==
X-Received: by 2002:a05:6e02:1181:: with SMTP id y1mr1520630ili.111.1592438433679;
        Wed, 17 Jun 2020 17:00:33 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id b22sm756149ios.21.2020.06.17.17.00.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2020 17:00:33 -0700 (PDT)
Date:   Wed, 17 Jun 2020 17:00:23 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Dmitry Yakunin <zeil@yandex-team.ru>, daniel@iogearbox.net,
        alexei.starovoitov@gmail.com
Cc:     davem@davemloft.net, brakmo@fb.com, eric.dumazet@gmail.com,
        kafai@fb.com, bpf@vger.kernel.org, netdev@vger.kernel.org
Message-ID: <5eeaae97bbe8f_38b82b28075185c4f6@john-XPS-13-9370.notmuch>
In-Reply-To: <20200617110217.35669-1-zeil@yandex-team.ru>
References: <20200617110217.35669-1-zeil@yandex-team.ru>
Subject: RE: [PATCH bpf-next v4 1/3] sock: move sock_valbool_flag to header
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dmitry Yakunin wrote:
> This is preparation for usage in bpf_setsockopt.
> 
> Signed-off-by: Dmitry Yakunin <zeil@yandex-team.ru>
> Acked-by: Martin KaFai Lau <kafai@fb.com>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
