Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24855282100
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 06:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725778AbgJCEFz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 00:05:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbgJCEFz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 00:05:55 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01F78C0613D0;
        Fri,  2 Oct 2020 21:05:55 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id y11so4550858qtn.9;
        Fri, 02 Oct 2020 21:05:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nN+E9EIMxPSBKg18ielUWPdflCd6G8az/zdi0ZiTn1g=;
        b=iPqyJ5joQmjAyjGEWQygndBgEcUx1tHj3cUORZEBGU3F6NeVnvfjRp2mpDm8GcKoOb
         lpDOzU3vl4QjKJZcDLb9lEOK7gwqtUjXoqaCEOrxOIXwTyMDvSL72qPl3ZeuR1A5GGzd
         /QKC4eknkfY0XUJTjxVWy3iaWY9YOEAkdR4zhM7O5O/NI5eEdmqb4oWmy+VdMrdXhRZi
         BF4e3VP87mW7y8gEdf5YCoao0FcGY/uI22n5hlaS/62sYm9iUL/rK7JWXdRq7g7cLbB2
         o0aRRLvrAVvvM97QR9i3SQWus2Fbh6zyy+Hog97Qcciv//hMagENgf99VAtUHG4//54C
         zM+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nN+E9EIMxPSBKg18ielUWPdflCd6G8az/zdi0ZiTn1g=;
        b=iTdmtFFBhFc6wnNR+NP6JgGWUx3WA2edfGbyrEpFDVVW4cgxF7nSWoOoqONQGaQkzt
         rrgWi7p0CG2xU4OSwALb+07/TA43MM7UgbdttbPWjh/7dbATPjMzn/P+qdO0Tn2ufNrs
         wNvor7wuDd/6G7+Id6iEwQgAtTv+6mQs/9Oynq/gZ9ticWFYHx5UBXoMfPha604dAlXo
         4Th6cJlGIDK4kpPEMudxG2WqIfEabb2joqRPszX1FBJUkGkOvyKaYpa5rjIt68/7b6kb
         sOI/t4LyIvGp5Dx4axDKz0BO1MiIwRvs22/i6BuwgWtet606h4eh2vRM/cNIH1tfQK3D
         YXsA==
X-Gm-Message-State: AOAM530cNBSaauKkJUnN6kJMjv7OY+E1ND49dWjBHxWR/ktF91ko3Rr/
        RlN2FRc7WfCLWBBnoWpTibA=
X-Google-Smtp-Source: ABdhPJyfKyvw6LN4/7URzJ268LRTjikXW3xvxqLZrcl4XjFOq+Vt0Sfzxht3Y1k7KXVEVsihEIDWyA==
X-Received: by 2002:ac8:735a:: with SMTP id q26mr5393488qtp.285.1601697954227;
        Fri, 02 Oct 2020 21:05:54 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f016:4433:ca7a:c22f:8180:c123])
        by smtp.gmail.com with ESMTPSA id v15sm2491005qkg.108.2020.10.02.21.05.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2020 21:05:53 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id F12C0C6195; Sat,  3 Oct 2020 01:05:50 -0300 (-03)
Date:   Sat, 3 Oct 2020 01:05:50 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>,
        Tom Herbert <therbert@google.com>, davem@davemloft.net
Subject: Re: [PATCH net-next 09/15] sctp: add SCTP_REMOTE_UDP_ENCAPS_PORT
 sockopt
Message-ID: <20201003040550.GD70998@localhost.localdomain>
References: <cover.1601387231.git.lucien.xin@gmail.com>
 <ff57fb1ff7c477ff038cebb36e9f0554d26d5915.1601387231.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff57fb1ff7c477ff038cebb36e9f0554d26d5915.1601387231.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 09:49:01PM +0800, Xin Long wrote:
...
> +struct sctp_udpencaps {
> +	sctp_assoc_t sue_assoc_id;
> +	struct sockaddr_storage sue_address;
> +	uint16_t sue_port;
> +};
...
> +static int sctp_setsockopt_encap_port(struct sock *sk,
> +				      struct sctp_udpencaps *encap,
> +				      unsigned int optlen)
> +{
> +	struct sctp_association *asoc;
> +	struct sctp_transport *t;
> +
> +	if (optlen != sizeof(*encap))
> +		return -EINVAL;
> +
> +	/* If an address other than INADDR_ANY is specified, and
> +	 * no transport is found, then the request is invalid.
> +	 */
> +	if (!sctp_is_any(sk, (union sctp_addr *)&encap->sue_address)) {
> +		t = sctp_addr_id2transport(sk, &encap->sue_address,
> +					   encap->sue_assoc_id);
> +		if (!t)
> +			return -EINVAL;
> +
> +		t->encap_port = encap->sue_port;
                   ^^^^^^^^^^          ^^^^^^^^

encap_port is defined as __u16 is previous patch, but from RFC:
  sue_port:  The UDP port number in network byte order...

asoc->peer.port is stored in host order, so it makes sense to follow
it here. Then need a htons() here and its counter parts.  It is right
in some parts of the patches already.
