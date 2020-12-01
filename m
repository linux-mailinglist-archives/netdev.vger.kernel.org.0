Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 572752C99F1
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 09:50:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728761AbgLAIuJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 03:50:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727153AbgLAIuI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 03:50:08 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30950C0613CF
        for <netdev@vger.kernel.org>; Tue,  1 Dec 2020 00:49:22 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id k4so2061491edl.0
        for <netdev@vger.kernel.org>; Tue, 01 Dec 2020 00:49:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=iiW0QYdBDiyOHkd/IpXWJ/1HIdQlBhwmcvpChKr1GSU=;
        b=KmPUPYVlQNBy5M5NIY0uvwvX0PEHbb6jB0iVWQ0YS1T7+cZdSprsuTQpp7QmGgdG71
         eEBxsLLiXUDxuKX2XJunwOJVXWVMw+9eSMNsYYhMemos55p6El5O6V0401vVS5RkPtRO
         kI6PUL3HkXxmXWkn9iMTmiuAXNMvkgrvfmqNw6Ng5qgVKZfONRYTFax9bOIX0mEF8NT0
         8l4GIyv9Zi2qaKBmLLVRapKlnGskIQAfRwMstnZ/agook+9IrMZXUrYgowlMTuk7SqeJ
         D5ZkY+T/6Rz2zc4B8vXj2ZSFO63m/lGD7sE6KALmWymMQCuGsF61UuDphobVCSLJljoF
         yRIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=iiW0QYdBDiyOHkd/IpXWJ/1HIdQlBhwmcvpChKr1GSU=;
        b=nnLKDOijEjuINbk7mn0APd9j2d1AP7z055C7cGA0oD2fVLs3Iq34O21Hx+h+amfK4P
         1zh6TthGuifgdHrRoCTSzVFNPdWPBNUfEGX8OUz/6CAKG7iugGFz0YhulpsmKnskjkQD
         7PT3wOwr3ylUy3YZ01Wy84b0/CU07EMCkOwa6NrYw30U/m4bCAc68RRVwhZRv/hl2m0p
         BbitBGxu+OeiOivnyEgeqvxWlgrPkAbdWzQMt+F0xuimMuBIXeTne4C2xNYlTk/x2yrl
         UM70DC400SuL6yAPU5AJDwKmo8Af38cXwOdf8m+Y5ntRwJRHaUCfNF+yiLfs/q3oJv2V
         nqBg==
X-Gm-Message-State: AOAM531JcaVX4rqIYbh67WfOyixD/rn3kfjdBxlLGPNWpYxF3F/5XIYb
        Wx3i0utcbdymRS5bEgqbVRyNB0ZfqZM=
X-Google-Smtp-Source: ABdhPJyOL9tfGJPU9aGEm3VVog6xXXy/4/eTACZyXOcFCR+4tqpOvh6qQ1DM2Mk0AK/ZgfH0hmXh2g==
X-Received: by 2002:aa7:cb02:: with SMTP id s2mr1859290edt.211.1606812560844;
        Tue, 01 Dec 2020 00:49:20 -0800 (PST)
Received: from unassigned-hostname.unassigned-domain (x59cc8a5e.dyn.telefonica.de. [89.204.138.94])
        by smtp.gmail.com with ESMTPSA id f8sm455539eds.19.2020.12.01.00.49.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Dec 2020 00:49:20 -0800 (PST)
Date:   Tue, 1 Dec 2020 09:49:17 +0100
From:   Peter Vollmer <peter.vollmer@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: dsa/mv88e6xxx: leaking packets on MV88E6341 switch
Message-ID: <20201201084916.GA6059@unassigned-hostname.unassigned-domain>
References: <CAGwvh_MAQWuKuhu5VuYjibmyN-FRxCXXhrQBRm34GShZPSN6Aw@mail.gmail.com>
 <20200930191956.GV3996795@lunn.ch>
 <20201001062107.GA2592@fido.de.innominate.com>
 <CAGwvh_PDtAH9bMujfvupfiKTi4CVKEWtp6wqUouUoHtst6FW1A@mail.gmail.com>
 <87y2in94o7.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y2in94o7.fsf@waldekranz.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 26, 2020 at 10:41:44PM +0100, Tobias Waldekranz wrote:
> On Wed, Nov 25, 2020 at 15:09, Peter Vollmer <peter.vollmer@gmail.com> wrote:
> > - pinging from client0 (connected to lan0 ) to the bridge IP, the ping
> > requests (only the requests) are also seen on client1 connected to
> > lan1
> 
> This is the expected behavior of the current implementation I am
> afraid. It stems from the fact that the CPU responds to the echo request
> (or to any other request for that matter) with a FROM_CPU. This means
> that no learning takes place, and the SA of br0 will thus never reach
> the switch's FDB. So while client0 knows the MAC of br0, the switch
> (very counter-intuitively) does not.
> 
> The result is that the unicast echo request sent by client0 is flooded
> as unknown unicast by the switch. This way it reaches the CPU but also,
> as you have discovered, all other ports that allow unknown unicast to
> egress.
> 

Thanks for this explanation. Would there be a way to inject the br0 MAC
into the switch FDB using 'bridge fdb' or some other tool as a
workaround ?
And is this behaviour the same with all other DSA capable
switches (or at least the mv88e6xxx ones)?  Will this change eventually 
after the implementation is complete ?

Thanks and best regards

  Peter
