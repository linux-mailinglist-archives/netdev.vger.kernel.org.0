Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA2D1599D9
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 20:35:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730275AbgBKTfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 14:35:53 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:55405 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729801AbgBKTfw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Feb 2020 14:35:52 -0500
Received: by mail-pj1-f66.google.com with SMTP id d5so1779349pjz.5
        for <netdev@vger.kernel.org>; Tue, 11 Feb 2020 11:35:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=L1zT4iXTmWfkI4wOwmMZ4o18MfCPpAamevZivwdVEg8=;
        b=D9wD+88CtwMSTo6hpt8CWePsexABKBgd3bM2lbSnUnErdTW3pUNzJUdCuGMAzLbOZz
         cDfhYUBxOrCJMOu9ol+HfjPC8DWM1NpgIgakMQcEVRijF9iFb5oyS13p8VGc+Bx5b8Ot
         A7O+sHqutssENyq01UVN0onEWX5QVZFLqdIT4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=L1zT4iXTmWfkI4wOwmMZ4o18MfCPpAamevZivwdVEg8=;
        b=BfXUYWDVP3GkFaZN92NirS0O0jDtpQScygdNG+D4PsBX9jTc25NAPjxGX2O3nn4Pyz
         vwC+B9HWRtRXIU3eCTJmHeIMGfTaUyJPEF6hyc6QuDbp71/G5+J4RQ8A0J5+WhIQA3l4
         KWYDn9NSutEr5ATaKs4gxro25d9r3mz23lJjvCvg5pIeAMos2i4WhRlwhmjZ38pNY+v3
         oQVxMgyOYKFcd4gViZaopn16SU7l+ur6xDFh2BRPSlModFQZ+O85kSC8gh3b2veW1K44
         U15mDajJ3KvK5fNbun+74MtW2XkPQAkXXvoFE57o8QMXS7nCVfiVoIEbxuw9fxk0hduv
         MHAA==
X-Gm-Message-State: APjAAAXCx7AVdEkMWX9pL6CN7eoaXAPXiSbwhNF536b8tR4IHGTM689G
        HISPnZMNfRrbKZ+FsSkqu+B2Rw==
X-Google-Smtp-Source: APXvYqyV7C7MX+UFBFOj086mAZSDkpLAhR277H/ITNkZlAITmYHn/RMBUw0+zaF3eCaXvQvEAnLGdw==
X-Received: by 2002:a17:90a:2004:: with SMTP id n4mr6984510pjc.20.1581449752154;
        Tue, 11 Feb 2020 11:35:52 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id 70sm5014226pgd.28.2020.02.11.11.35.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2020 11:35:51 -0800 (PST)
Date:   Tue, 11 Feb 2020 11:35:50 -0800
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH] treewide: Replace zero-length arrays with flexible-array
 member
Message-ID: <202002111132.4A4F073CAF@keescook>
References: <20200211174126.GA29960@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200211174126.GA29960@embeddedor>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 11, 2020 at 11:41:26AM -0600, Gustavo A. R. Silva wrote:
> The current codebase makes use of the zero-length array language
> extension to the C90 standard, but the preferred mechanism to declare
> variable-length types such as these ones is a flexible array member[1][2],
> introduced in C99:
> 
> struct foo {
>         int stuff;
>         struct boo array[];
> };
> 
> By making use of the mechanism above, we will get a compiler warning
> in case the flexible array does not occur last in the structure, which
> will help us prevent some kind of undefined behavior bugs from being
> unadvertenly introduced[3] to the codebase from now on.

Is there a compiler warning we can enable to avoid new 0-byte arrays
from entering the kernel source tree? I can only find "-pedantic" which
enables way too many other checks.

-- 
Kees Cook
