Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22153266434
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 18:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726260AbgIKQdG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 12:33:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726655AbgIKQc6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 12:32:58 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38FD4C061573
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 09:32:57 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id j11so14648966ejk.0
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 09:32:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XQzFj654VJ5MQVNbiywhxBvA8aKHO9s69SrWkx5Q92E=;
        b=FN18hhmfke4xI0bGcz4WeLgoE6qFU+0tdpgXk3qJD8jgSMZ/gNZamlzJoIljj5l6nd
         7nmbKZKMRtxLZCUBNUgtIM5bApQg8nzvNT2XPYTRFlHKwvXS+4ia0tZGYTZhNvsOwiq7
         uKnwB2wmeua771FXjOwBAmQfwRytg8sIcQkBEP6cQhP6QWvuVEr66yKLhRUF/X3V9OFj
         EGPTK9q9EM8VyeWA3E7oeLg3VhqXPGt6qvAcjNjIbqua5HL9kwrm9LF0EIQIvuhse9Te
         60THrNYUIABPwi+XgwFBQ16rQkVyqzMf5QN/3N+mMYCWWrqru7QuNNhTuKOCIWWLVmTR
         kNRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XQzFj654VJ5MQVNbiywhxBvA8aKHO9s69SrWkx5Q92E=;
        b=i4++1oTwC+ufU5CwAVfW1Zu1fvKt+yQhMegMuxSVkizuEXBxtHqRilW+t+8yN/gIir
         2QkOGaQ0qhHePztE18kxdOGziNbUIsWZoVx7R3YhGeaKsZdX7ivlAe7VROjaqD71gSv9
         2/A5zcCoAItuCrE9uNqcuIaZGkMXduBrACndrpKkGZI2md3keXMveyrk3zwnkebl65RX
         chvzS1nqqyNe4vdGwlMPYYxDRFF/3EOVXevCOyiaM8sdUs41ft0Mm8Zc1XtRBTKhqF2m
         kmw5MEpbriG7VVRmx4YxeNXKlEytuz3L6dWJu5rkxa7PYI7DirnFIhq28JtI5v4M6/P6
         4gXg==
X-Gm-Message-State: AOAM532tlN9bUUzrbDYeA6FWE0wDX8McU3nit8RRtf6O57F45F/9wlNo
        mDQe5Cg78ufiozZcw4VsejI=
X-Google-Smtp-Source: ABdhPJyLUFMWxlHhsklMRjJgU5cfZ/WWvIGABl9SZXUosciNx9Dfwk8SwkTB0t8+RHi+NERcfeT8Ww==
X-Received: by 2002:a17:906:4046:: with SMTP id y6mr3019873ejj.148.1599841975943;
        Fri, 11 Sep 2020 09:32:55 -0700 (PDT)
Received: from skbuf ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id ly16sm1913204ejb.58.2020.09.11.09.32.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2020 09:32:55 -0700 (PDT)
Date:   Fri, 11 Sep 2020 19:32:53 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: VLAN filtering with DSA
Message-ID: <20200911163253.owq3u42mdxkglann@skbuf>
References: <20200910150738.mwhh2i6j2qgacqev@skbuf>
 <a5e0a066-0193-beca-7773-5933d48696e8@gmail.com>
 <20200911132058.GA3154432@shredder>
 <20200911163042.u5xegcsfpwzh6zkf@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200911163042.u5xegcsfpwzh6zkf@skbuf>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 11, 2020 at 07:30:42PM +0300, Vladimir Oltean wrote:
> Currently there are other places in the network stack that don't really
> work with a network interface that has problems with an interface that
> has "rx-vlan-filter: on" in ethtool -k.

Wow, I should learn how to write.
I meant:

Currently there are other places in the network stack that don't really
work with a network interface that has "rx-vlan-filter: on" in
ethtool -k.
