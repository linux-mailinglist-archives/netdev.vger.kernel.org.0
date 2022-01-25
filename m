Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE82F49AA81
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 05:38:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1326028AbiAYDjo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 22:39:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1312914AbiAYCrG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 21:47:06 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82938C08118D;
        Mon, 24 Jan 2022 16:05:14 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id j23so54440562edp.5;
        Mon, 24 Jan 2022 16:05:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LqtTZJJS+DuJnUoPPxfP5zYuoYB4Rs8EWL7kEIrwG24=;
        b=ibXrjc29K9+PFIfTeLx1Lxucf/xWbRvcHFlDOTHrkLhJHd8qlmgOA5VY/od8cbW2ni
         nMbRjFB0ZKgLIEjuZZOex9znIMtnU94Yi/TK90xe/5UcXXhOK29/+VFfHTP8WgSE4fPl
         5XF1iHBBNtDI7BG/ikjcu1v0Eber71joc+IFzMqI6wYmewDNZIQU02pvVHWbUFuV3iP2
         WGZiSOyYLqWKGle3NNAj+QmKg6hWi3SI5axc2Im932dADn36QZMJVn9OF6tMNhaZFemW
         W3jG78/zrfrwbbbUTUIJTwjS8u+9QbMuAmq4SBEP+3tX0QxyTczOpsYv6HgwRDtcl2H/
         DBaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LqtTZJJS+DuJnUoPPxfP5zYuoYB4Rs8EWL7kEIrwG24=;
        b=S7j4dC81OV1WX/PLpB5QtWblxC9T3S66wAxA1hin2GXLKVZn/Cmq5NAl3KHnENLqsS
         gOAHqvA71TI+HxB2Xo6QYsXv5apfxLW6Aqq7KutgrK1R1799jn7yshi7ZbAIWa0vWYQh
         fGrGGynP3M9+9UbPHjtJbbeK2dsML4DAyrvp0H2Vl61+mXpx0aE7z2bXoFN6uwp33Ctr
         H15yaT2pTiRlDToIp8KRj3vL6fALy10cQGPewELHuGoH37EMzYVJ9z/llneAs9hu9PaY
         BzClO1GMUC66nVozLfrsYXOLKvn0L2pOAKX6/j5CDreJzyQ6S/V6aokBbhSst2epqvWl
         Y8Lg==
X-Gm-Message-State: AOAM5324Z3CK+5VzfoadF7nJF1NulPPwPWuiolqWab4UBaemnb8744xs
        ArC12DM+xWpUVCB83zik6YqQttpSY+U=
X-Google-Smtp-Source: ABdhPJyu4EhknJPBIadru/z1uc/Sm2oPuZXKuVuUp5FtKPF3lG0c8yu5fwyEDdSgOkSZC39YXDazVw==
X-Received: by 2002:a05:6402:1112:: with SMTP id u18mr18264945edv.150.1643069113153;
        Mon, 24 Jan 2022 16:05:13 -0800 (PST)
Received: from skbuf ([188.25.255.2])
        by smtp.gmail.com with ESMTPSA id kq16sm5419982ejb.163.2022.01.24.16.05.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 16:05:12 -0800 (PST)
Date:   Tue, 25 Jan 2022 02:05:11 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 1/2] net: dsa: Move VLAN filtering syncing out of
 dsa_switch_bridge_leave
Message-ID: <20220125000511.oabwtychzodqghjx@skbuf>
References: <20220124210944.3749235-1-tobias@waldekranz.com>
 <20220124210944.3749235-2-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220124210944.3749235-2-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 24, 2022 at 10:09:43PM +0100, Tobias Waldekranz wrote:
> Most of dsa_switch_bridge_leave was, in fact, dealing with the syncing
> of VLAN filtering for switches on which that is a global
> setting. Separate the two phases to prepare for the cross-chip related
> bugfix in the following commit.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
