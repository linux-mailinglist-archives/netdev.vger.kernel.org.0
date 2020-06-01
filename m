Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD351EB141
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 23:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728914AbgFAVoj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 17:44:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:36538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728360AbgFAVoj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jun 2020 17:44:39 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40496206E2;
        Mon,  1 Jun 2020 21:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591047878;
        bh=3GvJTphYH4pfc8EouAYGjuZ6km2vxfHOOChO0Q8xYH4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cwfFQgKXWs+BZC6F9wn9QNjecIAW0Y8p3XxqmR5ueXeBBp95YJyTSy3a7ObAi8NAC
         5pEt0qdV5z91ladt7Vk9snFWXW4brectmfvdhNh+WTdgP20CgGNYcMLG9wn470HknP
         7xwG4oVbAPSlzz05jMEXGyum9DDnvQMquwy4mPp0=
Date:   Mon, 1 Jun 2020 14:44:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Michael Chan <michael.chan@broadcom.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, Jiri Pirko <jiri@mellanox.com>
Subject: Re: [PATCH v2 net-next 1/4] devlink: Add new "allow_fw_live_reset"
 generic device parameter.
Message-ID: <20200601144436.75bab03f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20200601063918.GD2282@nanopsycho>
References: <CAACQVJpbXSnf0Gc5HehFc6KzKjZU7dV5tY9cwR72pBhweVRkFw@mail.gmail.com>
        <20200525172602.GA14161@nanopsycho>
        <CAACQVJpRrOSn2eLzS1z9rmATrmzA2aNG-9pcbn-1E+sQJ5ET_g@mail.gmail.com>
        <20200526044727.GB14161@nanopsycho>
        <CAACQVJp8SfmP=R=YywDWC8njhA=ntEcs5o_KjBoHafPkHaj-iA@mail.gmail.com>
        <20200526134032.GD14161@nanopsycho>
        <CAACQVJrwFB4oHjTAw4DK28grxGGP15x52+NskjDtOYQdOUMbOg@mail.gmail.com>
        <CAACQVJqTc9s2KwUCEvGLfG3fh7kKj3-KmpeRgZMWM76S-474+w@mail.gmail.com>
        <20200527131401.2e269ab8@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <CACKFLi=+Q4CkOvaxQQm5Ya8+Ft=jNMwCAuK+=5SMxAfNGGriBw@mail.gmail.com>
        <20200601063918.GD2282@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 1 Jun 2020 08:39:18 +0200 Jiri Pirko wrote:
> > If the permanent (NVRAM) parameter is true, all loaded new drivers
> > will indicate support for this feature and set the runtime value to
> > true by default.  The runtime value would not be true if any loaded
> > driver is too old or has set the runtime value to false.  
> 
> This is a bit odd. It is a configuration, not an indication. When you
> want to indicate what you support something, I think it should be done
> in a different place. I think that "devlink dev info" is the place to
> put it, I think that we need "capabilities" there.

Could you explain the need for "capabilities" under dev info?

I don't like catch-all mechanisms in principle. Better if capabilities
are expressed by the API dedicated to configuration of a given feature.

In this particular example the ability to do live reset is clearly
expressed by the presence of the parameter (as implemented by this set).

