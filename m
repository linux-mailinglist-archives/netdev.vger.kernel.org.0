Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FDDB1DA721
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 03:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728351AbgETBYc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 21:24:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726348AbgETBYb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 21:24:31 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45E9BC061A0E;
        Tue, 19 May 2020 18:24:30 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id t16so651901plo.7;
        Tue, 19 May 2020 18:24:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xa5MtFJjQsIx4vi/R4a9Jp5eS8vux0HNKOumA6xWjWc=;
        b=LH6UjH5H1X14IekldSSRbNeduqLyJbnPSYmMui3QN9GkjMlydCLlp3DQpudnSSvIwF
         KJit73ZmJKLo9pCUV9bTFIAZ3+Ca1nz9ULhE3Ow8qkfnLdaNExYFA5Tx1leUazL7BVso
         SI78DUhkmqn9NhVkz5cOvwIBZwTobTZP3qywtcD6WkETGrbdVX2bq7ReMVxfY63pic9/
         lm5q5Qyp1IWZmWFE1lZMHPHMgSYJDLfYgcfDa1p19YekMP6Fbzd8k/U0/DpUOmoqQ3m6
         eSsPxjwUvq9N/0si4Eo1HL3aMZNVstAB2SenCwdq5x2bStKsvogU/Ky7UAQRpsS15nJ4
         XjQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xa5MtFJjQsIx4vi/R4a9Jp5eS8vux0HNKOumA6xWjWc=;
        b=fiRiY/GB++E6Hf5eRI/yla4DJppluA73c1EvcTeUe2PUz25TaRMyRTOeGrIJ2GwOQo
         A9g8SiyMJQ0UyBZbdKNqQYx+YYY+ZJfvGNSkeH5W9ap8phjGKkSjB491Oysw3DwPIdWY
         NbBm8BukLEnd8QV6XKP7IeCFvHzHrzboi3203vV516sOsdKmq9lWyXDUvJEZpErtkRJQ
         Q8O9shsFgXh2HYwFTKj9A0Z9QC7jgDYGoA2N3QWpzNfj10tidkJdS2e7Goii9RgACnVy
         srEfXnrkSkRtFmx0lOMj8pFZ8/fAB3/nyBy73tY21YSFSHv7J+wE0n2bsGZ5TLBToqaR
         ipqQ==
X-Gm-Message-State: AOAM530gb4mRn9QTovbTvnGekWBZctavlGzKPTsdcGFyy+f6daZ1N3OZ
        wLEQq3j+GzSMUNroGsSJOEUl7X4S+q3Jpg==
X-Google-Smtp-Source: ABdhPJwJcjGTLuKIq1T6KGK8ED0hLbK3pFcKuCzzVKsPOaofBrsJHTJSvKnaQp5/ilBgt0Y8Teny5A==
X-Received: by 2002:a17:90a:bb85:: with SMTP id v5mr2260746pjr.150.1589937869887;
        Tue, 19 May 2020 18:24:29 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y18sm574437pfr.100.2020.05.19.18.24.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2020 18:24:29 -0700 (PDT)
Date:   Wed, 20 May 2020 09:24:18 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: Re: [RFC PATCHv2 bpf-next 1/2] xdp: add a new helper for dev map
 multicast support
Message-ID: <20200520012418.GG102436@dhcp-12-153.nay.redhat.com>
References: <20200415085437.23028-1-liuhangbin@gmail.com>
 <20200424085610.10047-1-liuhangbin@gmail.com>
 <20200424085610.10047-2-liuhangbin@gmail.com>
 <87r1wd2bqu.fsf@toke.dk>
 <20200518084527.GF102436@dhcp-12-153.nay.redhat.com>
 <20200519121512.0b345424@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200519121512.0b345424@carbon>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 19, 2020 at 12:15:12PM +0200, Jesper Dangaard Brouer wrote:
> Performance testing on a VM doesn't really make much sense.
> 
> Pktgen is not meant to be used on virtual devices.

Thanks, I will try on a physical machine.

Cheers
Hangbin
