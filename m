Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25887F01BC
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 16:42:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389972AbfKEPmh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 10:42:37 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36124 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389399AbfKEPmg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 10:42:36 -0500
Received: by mail-wr1-f66.google.com with SMTP id w18so21968618wrt.3
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 07:42:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ihWl6tbPxjGEAfGSpYgRl/v+8P5acse/QfPFY9bQYv4=;
        b=jtFKvW/3NrrKUNLCW6tunBqhmsxRLFXCBK7g3Oo7rknvY6A7mhGfcG6ZbLcxy/bs2V
         Yizwshz0ZxR3lAL87YXza4xTxYVqaOCDG4Wq/CcVcT0/LAOc5w7mPEiycRKexq/o6CbR
         UL8TUu6CuQxIzdSc4ciMo3EcxA/cFGupzNeBaZHNZTFOWICC+2TB3utIkKmJ4oyy4cI7
         o4qp84k+uua7lRXLCPTfIjub8ZNdKr1tlgdjKCMCqUM72D22HBzDjyTj94UHXs1ZjT06
         LnLjZkCwCO0OnxodHCPWuZ98f8y4wVmf9lqTcuMnu9m1m6ZtAT2pvkDckFC48O7ur9WP
         p6Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=ihWl6tbPxjGEAfGSpYgRl/v+8P5acse/QfPFY9bQYv4=;
        b=r69B5nXmaBiDQVFT7rf42abV9c9ZDJjkW5ke67zlgvFU0M0AAMOGoYiAKdg7op0EeR
         khSTkQVpMbAAOHGxp60NvNReEAqw7c/NuRyHHR15nSh5u/kIlI6jbCq7AuLpA01Yjjk3
         Uz/aLdNv/J3CuKhs94DOjRKVdIunEZh5pPdg1tWub8ETeFS+1DwaMAsFzgQjHyyNcg/u
         IggIZPyUeLoN4QY8BBWPgLI0y/qOY67hDqcKSpFU8pvTxGQoT6yKqc6TFhHIoNpMX6tm
         1fXtvTRnWQ/IclITtS1Xqg/fnzpZY0qaXa1qZMDDbJjpEL+vfgdBwRQyi55f5toUW4C3
         0Bhg==
X-Gm-Message-State: APjAAAWaUKXJuvmWc671r/Jvzp4PGZVYjS07/YoEAYjQcakz7p/A24In
        XaYu5kGN7QkH08XinrXide5kcg==
X-Google-Smtp-Source: APXvYqx8kC0WQWfv9qPkY5bcs/nSmWc7axoqe1afbOX2XUVdmOqx3cnUP+JzYrgAFN8OVrrc2n1jaA==
X-Received: by 2002:a5d:4982:: with SMTP id r2mr22885116wrq.254.1572968553045;
        Tue, 05 Nov 2019 07:42:33 -0800 (PST)
Received: from ?IPv6:2a01:e35:8b63:dc30:f096:9925:304a:fd2a? ([2a01:e35:8b63:dc30:f096:9925:304a:fd2a])
        by smtp.gmail.com with ESMTPSA id y67sm2257449wmb.38.2019.11.05.07.42.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Nov 2019 07:42:32 -0800 (PST)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH 2/5] rtnetlink: skip namespace change if already effect
To:     Jonas Bonn <jonas@norrbonn.se>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net
References: <20191105081112.16656-1-jonas@norrbonn.se>
 <20191105081112.16656-3-jonas@norrbonn.se>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <1a6ff19a-36f5-ec3e-3616-5dc142635223@6wind.com>
Date:   Tue, 5 Nov 2019 16:42:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191105081112.16656-3-jonas@norrbonn.se>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 05/11/2019 à 09:11, Jonas Bonn a écrit :
> RTM_SETLINK uses IFA_TARGET_NETNSID both as a selector for the device to
> act upon and as a selection of the namespace to move a device in the
> current namespace to.  As such, one ends up in the code path for setting
> the namespace every time one calls setlink on a device outside the
> current namespace.  This has the unfortunate side effect of setting the
> 'modified' flag on the device for every pass, resulting in Netlink
> notifications even when nothing was changed.
> 
> This patch just makes the namespace switch dependent upon the namespace
> the device currently resides in.
> 
> Signed-off-by: Jonas Bonn <jonas@norrbonn.se>
Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
