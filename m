Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0B4E4F0D4F
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 02:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238277AbiDDA5d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 20:57:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236423AbiDDA5c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 20:57:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C964265DD
        for <netdev@vger.kernel.org>; Sun,  3 Apr 2022 17:55:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649033735;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5TH3VOtQnq9UWcgZH0Ewk7ADU8ueI7W55qFtlz3f0kA=;
        b=h75bzVdyvfL++Perps8vbE1nl9rgSZ+dbxIe3a5DOJBG3XiBII9qJmz8bMgRoH2W4dT2Yi
        KRJdygpN5191uVl6dw1rsVR5behsuaf9uiNJtbqQjEDbtOf6XUT7HkOYmBjaKReyADKsc2
        6/B3/Gsu3hqe6y8KMqBYCqA6dTY80yU=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-602-6qrXWm-HPQyD0bxsZfYKzg-1; Sun, 03 Apr 2022 20:55:34 -0400
X-MC-Unique: 6qrXWm-HPQyD0bxsZfYKzg-1
Received: by mail-pg1-f199.google.com with SMTP id r19-20020a635d13000000b00398cdd429f8so4699374pgb.9
        for <netdev@vger.kernel.org>; Sun, 03 Apr 2022 17:55:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5TH3VOtQnq9UWcgZH0Ewk7ADU8ueI7W55qFtlz3f0kA=;
        b=jcvbqcrRn9IhOSWXMYMl1HHpMCC+ivnht5HjYrMYne8c+fGuJJF5Sfy0J6FpL3pxVN
         x6mcDnx+oqQf7xfZEw00miJi57BVCy4DfNfejNfBFkLJHqLypZpW2KLq3HBYw2JCAqWw
         k3CkEQEWuytVKSOcWSCbuyiDcHjSdAx4L0XDfatUNHIsdZFC+ubao66lPfx0n8WbXWvn
         VGjqC90hCywBjwrSgCJGb/rEg+H2q7iGQWOs6C5WmJZN/0I9kfjngI8a6Lf/AO10ekgv
         swnF5+TkUA6TdPfMb2dailtyXf3RAYmn9UHZGmu7m0/+huBNSTLTOhct2immLEN+Nb73
         Y7Qw==
X-Gm-Message-State: AOAM531olg2ZPt7DpME6B8Wc8aRwboKsN81+iMfsuXGHgaPmYncUxcHY
        v1VcH9pXgW8xBt4SlttSKwR1f+R9LIW/vLETSgL/fE+PUpVo+UA9DY8RAj28fUPJ9p9GRNaKIVp
        +0QAMSwtnIABmXAsS
X-Received: by 2002:a63:bf0e:0:b0:386:361f:e97a with SMTP id v14-20020a63bf0e000000b00386361fe97amr23625861pgf.552.1649033732926;
        Sun, 03 Apr 2022 17:55:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxuI/FhtGE/aUoanU7fXnPFHjMPRFWRKPtrveQqkx4G3PFyJv5fFS8EWdYk9E5VWX5NmQVGJw==
X-Received: by 2002:a63:bf0e:0:b0:386:361f:e97a with SMTP id v14-20020a63bf0e000000b00386361fe97amr23625845pgf.552.1649033732549;
        Sun, 03 Apr 2022 17:55:32 -0700 (PDT)
Received: from fedora19.localdomain (2403-5804-6c4-aa-7079-8927-5a0f-bb55.ip6.aussiebb.net. [2403:5804:6c4:aa:7079:8927:5a0f:bb55])
        by smtp.gmail.com with ESMTPSA id qe15-20020a17090b4f8f00b001c6f4991cd4sm19138309pjb.45.2022.04.03.17.55.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Apr 2022 17:55:31 -0700 (PDT)
Date:   Mon, 4 Apr 2022 10:55:27 +1000
From:   Ian Wienand <iwienand@redhat.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] net/ethernet : set default assignment identifier to
 NET_NAME_ENUM
Message-ID: <YkpB/2idmtgz10eV@fedora19.localdomain>
References: <20220401063430.1189533-1-iwienand@redhat.com>
 <Ykb6d3EvC2ZvRXMV@lunn.ch>
 <YkeVzFqjhh1CcSkf@fedora19.localdomain>
 <YkiYiLK+zvwiS4t+@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YkiYiLK+zvwiS4t+@lunn.ch>
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 02, 2022 at 08:40:08PM +0200, Andrew Lunn wrote:
> So is there a risk here that Xen user suddenly find their network
> interfaces renamed, where as before they were not, and their
> networking thus breaks?

Well, this is actually what "got" us.  The interfaces *are* renamed on
CentOS 9-stream, but not on earlier releases, because systemd makes
different choices [1].  Tomorrow someone might "fix" something in that
systemd/udev chain that flips interfaces without specific use flags
back to not being renamed again.  I'm certain it would vary based on
what distro and release you chose to boot.

> Consistency is good, but it is hard to do in retrospect when there are
> deployed systems potentially dependent on the inconsistency.

As noted, it is already the case that if your names are falling into
this path, they are unstable? (there are many pages for every distro
that go on and on about this, systemd/udev interactions, rules, link
files, and so on; e.g. [2]).

I get what you are saying, that in a fixed virtual environment booting
some relatively fixed distro, perhaps the names are "stable enough"
and nobody has bothered updating this yet, so everyone is probably
happy enough with what they have.

But ultimately it seems like nobody is regression testing this, and
all it takes is a seemingly unrelated change to struct layout or list
walking and things might change anyway.  Then the answer would then be
-- well sorry about that but we never guaranteed that anyway.

Reflecting reality and labeling the interface as named in a
unstable way just seems like the way forward here, to me.

-i

[1] For too much detail; it wasn't actually the interface renaming
    that was the problem, as such; but udev issuing a "move" event
    rather than an "add" event that our custom udev rules didn't match
    for (our bug, uncovered by this).  Of course it's more
    interesting, because the Xen cloud is the only one that doesn't
    use DHCP.  So although we were missing the event on the other
    clouds where things were renamed, we didn't notice because that
    rule was ultimatley a no-op in that situation anyway as it
    auto-configures.  It was only on Xen that networking was not
    configured.

[2] https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/configuring_and_managing_networking/consistent-network-interface-device-naming_configuring-and-managing-networking

