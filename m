Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C648455B62
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 00:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbfFYWiL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 18:38:11 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:33129 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbfFYWiK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 18:38:10 -0400
Received: by mail-lf1-f66.google.com with SMTP id y17so173157lfe.0;
        Tue, 25 Jun 2019 15:38:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=57nh9LzggZk/LxOVK95V+eMaGeFdODYcYnlMlFniAXY=;
        b=tuL05odjerGQqoZGt7FnNFMcjE2xbKf93l9RrOSBT8Eoxsla+ZgqT0RCcJg/WzjHzH
         Ff1elEuvKQv+6Sq4mowsGOb5zJeLy4pkc8NX6fXphhIfsWGnOyD0X9d9gGi8xJAM2xnu
         7+3X/Tgn1laYhJqjCSfHG2s36mo/IP5OGDLGwV5ff33tXK7YVdusVrlu2mmTs3GOsJal
         bZNy3fLHTGQH0pe3TPO/Xb0VkZ6pXdn0d8wrq8KDp1dVDB4hvikiuO9QW4iz/HO2lOO6
         Mhp0t87i7lyrMEoqab0sPDlV8JElnhP5VPCBGJRVoaRWCxG119nnzuDsRRIqReAMXXyN
         c5bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=57nh9LzggZk/LxOVK95V+eMaGeFdODYcYnlMlFniAXY=;
        b=ixCHIFnlGxcS+so0DIgtvC2MXjRInGV9GSU1GY3zYhDAr/1TrLGFIn2IKjkiJ6fmuQ
         H/HXJu3t5BlIqkWPyoqkgKcOnpCNutAuqR8bhY1lhMXgHHzPtMnzI31YN/zGnmIVTcBu
         a2qrUrBWFBFak7KxDvO6k+a2cYkrQDWsm06PYvcS+FSIjWbIRvW8VTA0SNXMecRAFckB
         OsdBAHxp0Z690s7deYjXME+1EplJV1IsQf9pbUp7IloWAAKNzRW5Zivop0lk8x6agyng
         GfjaAaA4358x+4pymGRjhs4FbKc+obguSZGRBq9Py911yvCRS9ctCOGNiOV+gzFGTg1S
         wDpQ==
X-Gm-Message-State: APjAAAUuelnHoGZPFHbI7BvLO4W7O/VxXHYOPuWbnb427eA+VK+kIDqr
        DhFVxIBk7cXns0VOsg1CGZ6YB+HChLr4ZLC2Whw=
X-Google-Smtp-Source: APXvYqw/tA51MMFChU5TVrgtP5MGJWwUTjySbf9Vh1pIqHfWFLZxrc8/r9o/QUu3//3Pult6ZC6UTy99vw51Oga5rvk=
X-Received: by 2002:ac2:5337:: with SMTP id f23mr631616lfh.15.1561502288415;
 Tue, 25 Jun 2019 15:38:08 -0700 (PDT)
MIME-Version: 1.0
References: <20190625222329.209732-1-allanzhang@google.com> <20190625222329.209732-2-allanzhang@google.com>
In-Reply-To: <20190625222329.209732-2-allanzhang@google.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 25 Jun 2019 15:37:56 -0700
Message-ID: <CAADnVQJVFp0pfon=vurWkcC5yvzt7vWW=DVGPqAZqCMWLEXEVw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 1/2] bpf: Allow bpf_skb_event_output for a few
 prog types
To:     allanzhang <allanzhang@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 25, 2019 at 3:23 PM allanzhang <allanzhang@google.com> wrote:
>
> Signed-off-by: allanzhang <allanzhang@google.com>

As Daniel mentioned SOB needs to have real name.
If you keep ignoring feedback we'll keep rejecting patches without comments.
