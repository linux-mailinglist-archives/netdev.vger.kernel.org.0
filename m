Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE6231E046
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 21:28:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233539AbhBQU2X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 15:28:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235047AbhBQU1s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 15:27:48 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB5BAC061574;
        Wed, 17 Feb 2021 12:27:08 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id u8so15248271ior.13;
        Wed, 17 Feb 2021 12:27:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=RMocf2fIvJPESPXX/Ghs5UCOZmgjX3r5b8wQ5tBDYtw=;
        b=rGkyqqCZyDct5mA7S9Ei+85o7kyIaKL3lgtbbNKwauonjnISwuOyLLDtBhdDje8SjG
         XdDraP/x2kzRC9OWa+rpcSiKfAZkTKxLITD/WVmbVN0Ztux0nmsp/tkL+gF99zKIveL0
         ZMxdAeYJXs/VTgeTnUW5MOOVxfD6CLA7fSYFQeK96YBeIPdPDUNgrakmzTLECm2mXKde
         HmlYzgHlS/Yy0O1k5tQ6zWimBj4W1tfhxbNyYqT9CO9o+d3NV5OSo5h23WfONvbA014d
         piGqi00raH9QiGkzq5f/csxDCwcz+LT0fT4lZPqm43OdtM8a6I3/i+DVTMfiXjZdZZP0
         Rhag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=RMocf2fIvJPESPXX/Ghs5UCOZmgjX3r5b8wQ5tBDYtw=;
        b=fVEmGo7qLW91I8cTxTukXyBjuMfQz/yDPYA880l6+aAIpT6hjwWNlE27Qahr9kZcix
         Za//1mrTN3NkA2H5GyZihZRc7HtW4DHqhJcuE+FcRq8+Xk1vwnpeQKsm/xp6AxaVxLvO
         0Rhq0noISZME8HQS6awppwP7+G6kVxS7adi0cH26AiupCCKbvdQPdP6iSpkEwRYoM9Qy
         lnlyRYQ6qlmWnMJZlIhVhBIJc9Ekb7UpqA+imRZQX7UWdZPhADSCvYQ/7hKTknht/cCW
         Q9RbDHxtMSScp1cr/qiGT92s7LVWSyxtVC2vm5Ny/HhxKsALR8kORO4135Y/JmXvGCX7
         tDEA==
X-Gm-Message-State: AOAM532cmatq+7sfgr3AKGQXQFJFmxE7ouAQCL5T1EzT00YEiow1FM4u
        AJjhIaLRzPSaRonxFz5WnceSQhWx9jw=
X-Google-Smtp-Source: ABdhPJyBHZS2AffaoGH52aM7tt7tf2Yx6H6YaBc0rA23R5qe8JbozJqOuAeIXqoI55Z1rhvaHx6Ypw==
X-Received: by 2002:a05:6602:26cc:: with SMTP id g12mr626808ioo.169.1613593628211;
        Wed, 17 Feb 2021 12:27:08 -0800 (PST)
Received: from localhost ([172.243.146.206])
        by smtp.gmail.com with ESMTPSA id j12sm1742585ila.75.2021.02.17.12.27.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Feb 2021 12:27:07 -0800 (PST)
Date:   Wed, 17 Feb 2021 12:27:00 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>, bpf@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Message-ID: <602d7c14330b1_ddd22087f@john-XPS-13-9370.notmuch>
In-Reply-To: <161340436783.1234345.9794055968782640674.stgit@firesoul>
References: <161340431558.1234345.9778968378565582031.stgit@firesoul>
 <161340436783.1234345.9794055968782640674.stgit@firesoul>
Subject: RE: [PATCH bpf-next V1 2/2] selftests/bpf: Tests using bpf_check_mtu
 BPF-helper input mtu_len param
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer wrote:
> Add tests that use mtu_len as input parameter in BPF-helper
> bpf_check_mtu().
> 
> The BPF-helper is avail from both XDP and TC context. Add two tests
> per context, one that tests below MTU and one that exceeds the MTU.
> 
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---

LGTM.

Acked-by: John Fastabend <john.fastabend@gmail.com>
