Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A593127B8E8
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 02:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbgI2AeC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 20:34:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbgI2AeC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 20:34:02 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8E49C061755;
        Mon, 28 Sep 2020 17:34:01 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id b17so1698745pji.1;
        Mon, 28 Sep 2020 17:34:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NBfZk/cUoZ2gvIR6ZYj29nkN4T4BMHB4CGqF0/GvBXk=;
        b=HZdCUAot4aoKf7H5C+YPQjnFrrppKoBibye2z1RM9bYAABoO0dhR5XrTmmaQpki51E
         nZWLoawLabCkeDPEXK4XwZ3rC99uH1/fFmoLX/8lyknKPwyJNwWZXJiaF6Gd5S5uvwwM
         w+VVjnRoONrItHL+ZrPlTjHiulwL0E6NomIr4Wa8RFqBmKmfi0mgrG3M7eUPXzZ4DrxO
         Du4yjTrf+Fp3qyAOQPFJX8DmtW2wgBVVgjH6rdT15O6cLQQrY9foZIUToC25zQ9rakeR
         fCXiAYPp3mHKFT+76HwSD+KNgfpwi0kzemHdwrVYpfPdmQVvpimYWpQGaWkbxxsDTMPG
         DuCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NBfZk/cUoZ2gvIR6ZYj29nkN4T4BMHB4CGqF0/GvBXk=;
        b=l9kschjzXaV3Sc/h1h/ufwxg0IqHfUTELQPNKnBmuXwR29JSGZv16Uv6BF32CCfn3x
         szqF3YeAlLf5HHGQkJpf6mscN1SllTVhuh+KsmpxA+s0bBej+ZnPYd+AemqHWx4kXmCW
         7UU49zdY/HuvJQbJgg5aqIMp/AdOdl4rP57N0iZSmVsyXWV8ZAiPSuyFXRmMh44GzJQ7
         /O/c0t+XRTf1njqYFg066dw9Et2ux3IFhQ9hwGE2k5+LJfJjAVKmnjnGoWfezoAbx4j6
         hPRbWpk+km+FvOaLfUpuGcTHkwjwRgZv6omejTcIiJ41Iq1SlSq425D+3OrQL1Yti4gM
         FaLA==
X-Gm-Message-State: AOAM530+7fkw6U2Kgvvi6BOAR52OdWmdDiIlPJU/lRphrNeXtjEr4EQI
        LIFd+O/UB3ZKYtcNCcUna6Y=
X-Google-Smtp-Source: ABdhPJzuBeNZEXoFc1fGjwBULi+ta4hLAKKd4hIrdA6XQTqLMePWPxWtiAbVh80D7F/Bi+mD8MEq2Q==
X-Received: by 2002:a17:90a:fd98:: with SMTP id cx24mr1430653pjb.181.1601339641296;
        Mon, 28 Sep 2020 17:34:01 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:8e77])
        by smtp.gmail.com with ESMTPSA id gk14sm2586045pjb.41.2020.09.28.17.33.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2020 17:34:00 -0700 (PDT)
Date:   Mon, 28 Sep 2020 17:33:58 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com,
        kernel-team@fb.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: Re: [PATCH v2 bpf-next 7/9] libbpf: add BTF writing APIs
Message-ID: <20200929003358.q742v2rx7j2k4iga@ast-mbp.dhcp.thefacebook.com>
References: <20200926011357.2366158-1-andriin@fb.com>
 <20200926011357.2366158-8-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200926011357.2366158-8-andriin@fb.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 25, 2020 at 06:13:55PM -0700, Andrii Nakryiko wrote:
> Add APIs for appending new BTF types at the end of BTF object.

I've applied the first 6 patches. This one had conflicts. Pls respin.
