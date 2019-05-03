Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E73D12887
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 09:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbfECHOV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 03:14:21 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:35949 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbfECHOV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 03:14:21 -0400
Received: by mail-oi1-f195.google.com with SMTP id l203so3726839oia.3;
        Fri, 03 May 2019 00:14:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/deaAp4CFer9cuf3bUXndYrCg9KM5AsG3HholmAxoSk=;
        b=fa08x6A8w0U4WW/LHPzr2TWva4sHEaByVVLQaLkVX9WT72ScgVL1qBC/t1HixV9P2g
         ++1UHuZp9SBVDcY1Q2BKGj+3xt47MayS9yvnd3s60HloTIlqSFLb8HD5O1vCejcVPkXH
         ZTwuGQSfFy96rXuUNyFTLPtjLOs4B5D5bwRJu9wFS1lJ1r4lO1SBXnYDNdWqBwQesSAO
         c0eEJ0cAtg30xM6T8gFayvaStWyUbf8GyEgJpLPtIQcjy2h5ySunHEFNG68z3jvO7bqe
         3S8bbOsbwWogx3Kt+cP8hiXePbgXM4JweRRe2tyJSCvDKgs0pZczV1sHPy5T35gkGCT1
         2edQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/deaAp4CFer9cuf3bUXndYrCg9KM5AsG3HholmAxoSk=;
        b=gp9aOVgabIJzYcKqreK8rSOADr72vHc4+vm7yKP+cYEvflj1rVQo1cWrCkChheDt+e
         0Bd2jt+B0JdWLTTKbNCq4Z9Sv4bIDKBmNfQsVYMAiQ7PjnY8MblAyZMDOryBf207duvY
         I6KfFj9EbEqOd+8AkygMoUFU28RRzHsf/gm+iv05qZ/i54V+Qlp+yhnyeniwg2PWwy0G
         O+xVuz77nOnxvlqDwGQ1FwGwqOEATudoBSBRY7Ou5n5Pwflo79F0f29PwczSFNLrx5uk
         T62yUSE/49yQnhriXgEvgfjaZDSC1Ju9o3Tsc+NB6wKOzVD2qejzimSfhXHrG8pZd03o
         vKVQ==
X-Gm-Message-State: APjAAAXowJc2HpAXrM0hHpdVirpanETCMoMolBg3tzz7NIm4u6SeGFgI
        07N1wY5wUuwBFuzUSnpuHyIoqEE4k0UpCJentr5qr8QY
X-Google-Smtp-Source: APXvYqwAq5AdVJhs8TqQKehPpWPoW6E68GK05JMEWvumCgrFYugTyRUV+hTD9H4eK10CDHgmM8ZhFCO70JV6JnkoE8w=
X-Received: by 2002:aca:b50b:: with SMTP id e11mr5031486oif.51.1556867660048;
 Fri, 03 May 2019 00:14:20 -0700 (PDT)
MIME-Version: 1.0
References: <20181008230125.2330-1-pablo@netfilter.org> <20181008230125.2330-8-pablo@netfilter.org>
 <33d60747-7550-1fba-a068-9b78aaedbc26@6wind.com> <CAKfDRXjY9J1yHz1px6-gbmrEYJi9P9+16Mez+qzqhYLr9MtCQg@mail.gmail.com>
 <51b7d27b-a67e-e3c6-c574-01f50a860a5c@6wind.com> <20190502074642.ph64t7uax73xuxeo@breakpoint.cc>
 <20190502113151.xcnutl2eedjkftsb@salvia> <627088b3-7134-2b9a-8be4-7c96d51a3b94@6wind.com>
 <20190502150637.6f7vqoxiheytg4le@salvia> <7c0e2fec-3bf8-9adc-2968-074e84f00bb4@6wind.com>
In-Reply-To: <7c0e2fec-3bf8-9adc-2968-074e84f00bb4@6wind.com>
From:   Kristian Evensen <kristian.evensen@gmail.com>
Date:   Fri, 3 May 2019 09:14:09 +0200
Message-ID: <CAKfDRXgTAcDUddtumR42p1XFSFEYCdYV69YXOG31sE9BtrnrAQ@mail.gmail.com>
Subject: Re: [PATCH 07/31] netfilter: ctnetlink: Support L3 protocol-filter on flush
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, May 3, 2019 at 9:02 AM Nicolas Dichtel
<nicolas.dichtel@6wind.com> wrote:
> >>> Let's use nfgenmsg->version for this. This is so far set to zero. We
> >>> can just update userspace to set it to 1, so family is used.
> >>>
> >>> The version field in the kernel size is ignored so far, so this should
> >>> be enough. So we avoid that extract netlink attribute.
> >>
> >> Why making such a hack? If any userspace app set this field (simply because it's
> >> not initialized), it will show up a new regression.
> >> What is the problem of adding another attribute?
> >
> > The version field was meant to deal with this case.
> >
> > It has been not unused so far because we had no good reason.
> >
> Fair point, agreed.

Great that the discussion has reached a conclusion. I will prepare a
fix based on the version-filed and submit it either later today or
during the weekend. Sorry again for the problems my change caused.

BR,
Kristian
