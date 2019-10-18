Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AFC6DCFBD
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 22:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2443396AbfJRUHn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 16:07:43 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:35019 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2440349AbfJRUE2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 16:04:28 -0400
Received: by mail-pg1-f196.google.com with SMTP id p30so3952996pgl.2
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 13:04:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=XV5u8oWZuxAZOxAM/n6++b2nyO3V0EIk3THkhJDzsUk=;
        b=pcROaHp5YAcKW1qweSg099v/ns2o0NqJF3Mxw3vWJ6sjUq6OAAVCgghoDmnqZhdPNL
         oPaABct/aLoPud1Anb416atf43PtRaLLmAoqPhaNL6YmgbvyjTs1aUcejc/aSjy3mS3v
         Auh3PqYWsMjRHg2CV/Jwfqp8JLEChkapQx07RxHOX98Y9zATPc97nncQYTMbbeg7jxds
         VXvK7nZ62Uf0MCle2cR1wC31lGAe+c9sZpUJ3uMVuTpmZ8IJhHXoQpaRtPkN3TcuhcbA
         DP8luaJlAtTpsEmiBEYCgqMCpQ/MLONUffLo5D/FFglSTrarybToZmp8HGY1Kt1m03sa
         ZZvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=XV5u8oWZuxAZOxAM/n6++b2nyO3V0EIk3THkhJDzsUk=;
        b=af5skOtY3mCQHMed65MLo9pigKoHTDi0Zmfe08/fzP6EEOFJaRsSUHSvRNnD8pnrrR
         /bQv+JcmJFluALBD3Qk9hUr0dp0MW447goCMBDeiOS9CW3vMMq83UfTCI2N8MTgudWZR
         e/8uaaA/12mjRAxABcXXEoMak5uck8wxbID3hPKYVTeLbB1ucj0KPjQlbaH30aVmuCUy
         JFD04URo61Rx+BqOfRXqNOBSHvKy4VK2ruPfeifEleY6EY/aUj1GKKHmPmAM6vAGHs5n
         3cHeQlWeBwdWSUbcZ1tqiG+NmN5npn99vpmOmYR2TYb0B3FcVrFvJb7L8SJ0+UbRm3Wc
         Sz9g==
X-Gm-Message-State: APjAAAWOMZW7BCbjQ3zNPnB7Vfgm3JSGGmXd6maMPT3B1+imyy3JILny
        Q701zuymxoLC6R7/3NFULIc=
X-Google-Smtp-Source: APXvYqz/cqSbQdTUwIW75nk7b8nnYJMv+G55exKU0hAm6SSzyxD6fd9y5vyEpqm7C4Qr8qkENJCwPQ==
X-Received: by 2002:a63:e249:: with SMTP id y9mr11891328pgj.383.1571429067654;
        Fri, 18 Oct 2019 13:04:27 -0700 (PDT)
Received: from [172.20.162.151] ([2620:10d:c090:180::d0dd])
        by smtp.gmail.com with ESMTPSA id i126sm8031056pfc.29.2019.10.18.13.04.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 Oct 2019 13:04:26 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Jakub Kicinski" <jakub.kicinski@netronome.com>
Cc:     brouer@redhat.com, ilias.apalodimas@linaro.org,
        saeedm@mellanox.com, tariqt@mellanox.com, netdev@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH 03/10 net-next] net/mlx5e: RX, Internal DMA mapping in
 page_pool
Date:   Fri, 18 Oct 2019 13:04:24 -0700
X-Mailer: MailMate (1.13r5655)
Message-ID: <3249A4F1-AF1D-4B7B-A23A-7F0086A8FCE9@gmail.com>
In-Reply-To: <20191016183300.63eb3cd1@cakuba.netronome.com>
References: <20191016225028.2100206-1-jonathan.lemon@gmail.com>
 <20191016225028.2100206-4-jonathan.lemon@gmail.com>
 <20191016183300.63eb3cd1@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; markup=markdown
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16 Oct 2019, at 18:33, Jakub Kicinski wrote:

> On Wed, 16 Oct 2019 15:50:21 -0700, Jonathan Lemon wrote:
>> From: Tariq Toukan <tariqt@mellanox.com>
>>
>> After RX page-cache is removed in previous patch, let the
>> page_pool be responsible for the DMA mapping.
>>
>> Issue: 1487631
>> Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
>>
>> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
>
> IIUC you'll need to add DMA syncs here, no? map/unmap has syncing as
> side effect.

The driver still needs to do DMA sync for data transfers,
this only covers the initial mapping.
-- 
Jonathan
