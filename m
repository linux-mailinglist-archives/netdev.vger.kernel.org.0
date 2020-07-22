Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72F4F229348
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 10:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727819AbgGVIUb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 04:20:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726147AbgGVIUb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 04:20:31 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1ACDC0619DC
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 01:20:30 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id p14so706870wmg.1
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 01:20:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AGO5oXC2NaEBZms9Zzvd2Ka4lOiXeYYL68h7WdCW7xI=;
        b=LJpl2hBN0SFsjG67XqGtJQn+tNX8kctXVNJojoT3N44DachISj7x/UMugDRxiISuzp
         vANMfx2UD27Wiq1sgbz4bja+0TMOWCz9yJgNW4SCHs0iljWvcRzlBSPaeqQDAI8acMsH
         xPD6ZWu/WyCOD/ozN5tdXgw1R7Bw/EFhULNaqyQAnOtfSbeOUL3ks4RAYVRV2wRaU9WV
         SLJRnT+Xmwsb2+OThTn9FUhZzLMIyg0njVzTw84s9xlPTNUxEPT2DGIe93mTAxFlmGwS
         MXP/MkYDZYrEZYyJdzVYuZbefn6KtYPGYCs56z0vGnzN0SrobbmPdTN9mAFaV2GsRM9n
         U7FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AGO5oXC2NaEBZms9Zzvd2Ka4lOiXeYYL68h7WdCW7xI=;
        b=Ev6ILaldwO4ofELEJenhuXtcmzs6Ns23/910JB+oBqS43Ku7b3Tt/sx0BWfRwWlaBB
         jDarRkk5mOHv1KMOXstfLHR5IofFOOQ1A8iUZHLD7SUsVJWReuEPkCJNPPBHslfr2wLA
         IXCjDDujS8X72vBi87x+mXo9gz74aF/9TQvl6WI9VIIjHFzPo50LYSrHvHEg0cCFBQoz
         AM4l88FSjMLO6Q4T4k8r3Hj5hHeRT+k7ppwAM2mXjHmJkQ3ElyTRV4gT5E8l//TIi3v+
         8k8gpOyNrsZB9Dthj2Ehjykf9OyyjDdc4qEhxkdKN/Nl5xfi15B/3Z7F7LsVu0vuW2Er
         BVnw==
X-Gm-Message-State: AOAM532laPDLZEngPL8L5j98q6fnR4km2gwut/9uCaup1wNoeGrRjsyE
        gNBLefAroGP9OxLE9yZBeVQ51A==
X-Google-Smtp-Source: ABdhPJwN9ffmcHmPB/OEIHDKByAPhM6CmSNwyL87+MyHHwPRmMtflIzDC4T04pj3pv4tWym0BbTCZg==
X-Received: by 2002:a7b:c5d8:: with SMTP id n24mr912005wmk.153.1595406029191;
        Wed, 22 Jul 2020 01:20:29 -0700 (PDT)
Received: from [192.168.1.12] ([194.35.117.140])
        by smtp.gmail.com with ESMTPSA id n5sm6509733wmi.34.2020.07.22.01.20.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jul 2020 01:20:28 -0700 (PDT)
Subject: Re: [PATCH bpf-next] tools/bpftool: strip BPF .o files before
 skeleton generation
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com
References: <20200722043804.2373298-1-andriin@fb.com>
From:   Quentin Monnet <quentin@isovalent.com>
Message-ID: <bae8109d-3f01-eafb-eff8-4df425771b2b@isovalent.com>
Date:   Wed, 22 Jul 2020 09:20:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.0
MIME-Version: 1.0
In-Reply-To: <20200722043804.2373298-1-andriin@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22/07/2020 05:38, Andrii Nakryiko wrote:
> Strip away DWARF info from .bpf.o files, before generating BPF skeletons.
> This reduces bpftool binary size from 3.43MB to 2.58MB.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Acked-by: Quentin Monnet <quentin@isovalent.com>
