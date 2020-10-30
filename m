Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3399A2A0122
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 10:21:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbgJ3JVG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 05:21:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726171AbgJ3JVF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 05:21:05 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E30DC0613CF
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 02:21:05 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id 7so7672244ejm.0
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 02:21:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zOMqHpkJaHowq/dDwqOe5W8I3TUfOpuTyPw7+Js6M2c=;
        b=iyx9eyDH7WmZazoHtD0wvDMdEYtOTYRkH5W2OXpABrc4DDaXQbyklGMqRgz7mysnO+
         SlkEF+X7roFQ5na7QYEJblzSeUk9yYmaoi5O04cnWP2jbaGHBpGugiOPzahjM+EZz7Mb
         fbt8P++bN5i+QWat46bs3qCK31COua4VddpDrjJq5bE76UsrUhy2jSr/g7fFj6foLlRz
         NIR9yaHAXNkmZOwd4xlHlLzHpUbYhB5EICY+J9swrOFixE07hjSx7NS0L4WNXbXQEM8F
         sCzZ+XtfmFFNYy+i3pCpTCwvYYIc0UOF+76uyD99d/HhjZjInnKxlBy/9Dic0Knv2ikr
         Zsxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zOMqHpkJaHowq/dDwqOe5W8I3TUfOpuTyPw7+Js6M2c=;
        b=FLy7LN4oA+RSfFKE6U9emAUt0UfH6NA+Gkvt6w0MmyPc6f5xBdsruSccaB5H6tNwFH
         hssAhKsLHiidjdWidjwL7JjF80qj8d3NMdzD0dptF6uET4PQYF6qtJsf3ai4VbOZVx3/
         25R1BPYwSWodLY4jv0WWS2kB68lt+nmlzwXa9cbJMFgDPCFf6CiHTUJQ2IPJbgxCmLk8
         NnT3cwJgsXNFntmjOyylDlHYc4KvMXKlOrIiISlqqMt3k0k3/1MZNgfbXVYQhBI5CjwZ
         CUd34soZiPDa0nFB+a2t3qzGFnpu3pXTQ00b4fdsJ7DXgAn0jbqO4LrA1pcJlFvhSHns
         rm/A==
X-Gm-Message-State: AOAM530AsiiZFJenGUEtfC5pOoUSw4CjT1/iC7lGuoABKPoqrKDJdfjL
        7UM4qMF+6HjLYq87zjTN1txC3B9kA1U=
X-Google-Smtp-Source: ABdhPJyw3HpHOK85AyJxA4OUFte4sjQqlxa4/iXBMVWwzkeMl1DBKqhRi0lmj/0XRT4w9EB01MeDtQ==
X-Received: by 2002:a17:906:3614:: with SMTP id q20mr1394774ejb.297.1604049664294;
        Fri, 30 Oct 2020 02:21:04 -0700 (PDT)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id b1sm2315583ejg.60.2020.10.30.02.21.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 02:21:03 -0700 (PDT)
Date:   Fri, 30 Oct 2020 11:21:02 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org, Ido Schimmel <idosch@idosch.org>
Subject: Re: [RFC PATCH 4/4] net: dsa: tag_edsa: support reception of packets
 from lag devices
Message-ID: <20201030092102.teympxo3hq6bfz4b@skbuf>
References: <20201028230858.5rgzbgdnxo2boqnd@skbuf>
 <C6P7J2EICLJ2.2QY1SQHL62MH3@wkz-x280>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C6P7J2EICLJ2.2QY1SQHL62MH3@wkz-x280>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 29, 2020 at 08:47:17AM +0100, Tobias Waldekranz wrote:
> Doesn't that basically boil down to the argument that "we can't merge
> this change because it's never going to be used, except for when it is
> used"? I don't know if I buy that.
> 
> How about the inverse question: If this change is not acceptable, do
> you have any other suggestion on to solve it? The hardware is what it
> is, I can not will the source port information into existence, and
> injecting packets on the wrong DSA port feels even more dirty to me.

I suppose you're right, I don't have any better suggestion.
