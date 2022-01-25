Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7284249BF44
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 00:01:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234555AbiAYXBm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 18:01:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234547AbiAYXBl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 18:01:41 -0500
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 539A1C06161C;
        Tue, 25 Jan 2022 15:01:41 -0800 (PST)
Received: by mail-ot1-x335.google.com with SMTP id x52-20020a05683040b400b0059ea92202daso12007701ott.7;
        Tue, 25 Jan 2022 15:01:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=NR6Pkk/NLS3eDNHWIfVB64jIoL3Ged0GrnyD1pBXw6w=;
        b=EbUXI95kVJPvvjukvKMbw/yhxSnQnecUxPZyOx1DU5gGD2h4+niDU8tOBbPZwBfEoP
         1aXGRLfEM5CNy3eoIhbKVtj/kUR/9Jw7HqM89+jFtpbVdPQN8QovzpDRxHAAiR+H9fhi
         LwRbmlC9JgVKWdm76EIcK6GgILAocULzdisO8Zj88u2ljfLjFn/ZWoT9fwo6ACb7no6s
         oddqUONOEcI7mJkjUrgRuY+zvQmtjyxa2v1mt44O/oH+kq+hHbruijMIqmGIrQ2XJCbK
         /WSW0x8nRYWpyuBKMr09qh5lZnP6K6xIhbOr5Q5AJ7x4V/QE/U/4yY1FVoFBxkiGeeg8
         14SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=NR6Pkk/NLS3eDNHWIfVB64jIoL3Ged0GrnyD1pBXw6w=;
        b=rUSemHLAGg+atJHr/MnJGVGeE0N8mjqAe5utCFHxUbH8z+lp9olnu3MvD/08lb5xUC
         9UkA3ChJWVlqAfxU6ZHFA7NUwLM6PrQKrbiHnGAPTDP8sIBSphZJo4wEcTLWf4B7z3h6
         cHC8JAsCykN8aHj1lBp6loZIA7h5CvM4ajayjIiZGp7/SX5ClAEnxSWFJq3VpzHz0WN9
         2E/E5NAu6xkI2ip54yo1H0+TbedHnbpr1sMWbAv5HvT8CvsArjr+Hj0IX5F0SXtU8yIO
         9gEt1wj0k+0UkJx3F7/Q/7Dx+Qemdj7Pu/B0GkXX7D/2gHIL584xmjdJhDtkdIpy+YlJ
         fWUA==
X-Gm-Message-State: AOAM532EvzuQWw/qK7GXw3QsAOUzn6a7+TvB5Kx0b/ZdTBgh6HnpjDwI
        MW2kv79mC0MHkdBhJ+9Y9sQ=
X-Google-Smtp-Source: ABdhPJywrXOrU/BvQ6rubLqGaMFfqIJ/dK1Gi06eo0oYpj760tktyaB9qEUO2I0h+zQXKzNZI9b4sw==
X-Received: by 2002:a05:6830:812:: with SMTP id r18mr464812ots.136.1643151700722;
        Tue, 25 Jan 2022 15:01:40 -0800 (PST)
Received: from localhost ([99.197.200.79])
        by smtp.gmail.com with ESMTPSA id v26sm4185317ooq.20.2022.01.25.15.01.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 15:01:40 -0800 (PST)
Date:   Tue, 25 Jan 2022 15:01:33 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, bpf@vger.kernel.org
Message-ID: <61f0814d74004_30a59208bf@john.notmuch>
In-Reply-To: <20220125082945.26179-1-magnus.karlsson@gmail.com>
References: <20220125082945.26179-1-magnus.karlsson@gmail.com>
Subject: RE: [PATCH bpf-next] selftests: xsk: fix bpf_res cleanup test
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Magnus Karlsson wrote:
> From: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> After commit 710ad98c363a ("veth: Do not record rx queue hint in
> veth_xmit"), veth no longer receives traffic on the same queue as it
> was sent on. This breaks the bpf_res test for the AF_XDP selftests as
> the socket tied to queue 1 will not receive traffic anymore. Modify
> the test so that two sockets are tied to queue id 0 using a shared
> umem instead. When killing the first socket enter the second socket
> into the xskmap so that traffic will flow to it. This will still test
> that the resources are not cleaned up until after the second socket
> dies, without having to rely on veth supporting rx_queue hints.
> 
> Reported-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
