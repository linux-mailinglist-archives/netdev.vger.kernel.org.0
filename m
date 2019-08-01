Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A2D27E4A2
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 23:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389069AbfHAVLh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 17:11:37 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:42967 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726888AbfHAVLh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 17:11:37 -0400
Received: by mail-pl1-f194.google.com with SMTP id ay6so32781158plb.9
        for <netdev@vger.kernel.org>; Thu, 01 Aug 2019 14:11:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=0xsv49hI9aGpjljOtgVwnXuEAi7FmjxIKLfqfg5dOL8=;
        b=NkhQbzpD4PFe0yt8N8n6078PZiu8nThoyzO+eWHONiylH5RDAwbpNe7a0OXIHacMcG
         Zm1IdF1ZAQTZJjczh2XUEqQN89wkYo23sVUjnZEPki33dJfdldxjKgUQzkMjOga+mmul
         TmJ1Mm7bdmc2Nn2vD0kvLs83SpzEUvXdZLf4JJkcm9PrQ7o4gzeOGJPwKsVP1JThvyeP
         0Gu3SIzi0N9A+p7cO+SEkNiUSElovhZVL16XqojpOHOHQJgobXpcpWTkOvJM/yOCs7v0
         xcbMm1EZh6XEZNAsUhw6KXEGKhYxLOjUuJnF+y8+SPz3jKtsJIY4DZGa74rNR320924o
         lmDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=0xsv49hI9aGpjljOtgVwnXuEAi7FmjxIKLfqfg5dOL8=;
        b=j4zh2HfqC7BljObuCc4D8bK+f3k7uR3dmucLZ9iAbj4RcSsV2TZAOLVm1iySU3pIEz
         nbbEu7UWbBRpRG2MX/W2t3JT/hpTS+q+WBXbCdWfMwz1Eb4hpB7XDzSAMWommbp/uqdX
         419jLbsZ0Vud9JkD+OfJfFcuALMK/7h6oR/EtOi2s9nhhY8Rg06Gs5iN/DEbpp+XS/3r
         KUWiK06rKrA1qt9wk8/tl5dRvsXy887FNgRUW5jSLzSerzumPEUaA4ZkbeK5qscXEaiY
         Izhebqr1j6B5V2iYobSoyz/vBHGUkACfsNdEb1UIOoR53rHJtG6LijA+BGo+65o6hpXy
         9htA==
X-Gm-Message-State: APjAAAXJZIzzoqPBN+cGc9FnBcG9rJeNXxAd2ENxhZxn+Yqw1hbH13CY
        MkFxIhrsXLhBNrlN8XdfNp8=
X-Google-Smtp-Source: APXvYqxMexpp9J8fnGl+bPhCseDlFmUhIGPFD20kLE91/lw53v7y7XMLXyig2C4wfsow7MF8zC2J8A==
X-Received: by 2002:a17:902:8bc1:: with SMTP id r1mr79221609plo.42.1564693896774;
        Thu, 01 Aug 2019 14:11:36 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id e10sm75633361pfi.173.2019.08.01.14.11.36
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 01 Aug 2019 14:11:36 -0700 (PDT)
Date:   Thu, 1 Aug 2019 14:11:35 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, ast@kernel.org,
        daniel@iogearbox.net
Subject: Re: [PATCH bpf-next 0/2] bpf: allocate extra memory for setsockopt
 hook buffer
Message-ID: <20190801211135.GA4544@mini-arch>
References: <20190729215111.209219-1-sdf@google.com>
 <20190801205807.ruqvljfzcxpdrrfu@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190801205807.ruqvljfzcxpdrrfu@ast-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/01, Alexei Starovoitov wrote:
> On Mon, Jul 29, 2019 at 02:51:09PM -0700, Stanislav Fomichev wrote:
> > Current setsockopt hook is limited to the size of the buffer that
> > user had supplied. Since we always allocate memory and copy the value
> > into kernel space, allocate just a little bit more in case BPF
> > program needs to override input data with a larger value.
> > 
> > The canonical example is TCP_CONGESTION socket option where
> > input buffer is a string and if user calls it with a short string,
> > BPF program has no way of extending it.
> > 
> > The tests are extended with TCP_CONGESTION use case.
> 
> Applied, Thanks
> 
> Please consider integrating test_sockopt* into test_progs.
Sure, will take a look. I think I didn't do it initially
because these tests create/move to cgroups and test_progs
do simple tests with BPF_PROG_TEST_RUN.
