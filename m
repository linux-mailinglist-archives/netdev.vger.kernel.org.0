Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0F7743AC6E
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 08:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234203AbhJZGxr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 02:53:47 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:46115 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231445AbhJZGxq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 02:53:46 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 3824F5C0240;
        Tue, 26 Oct 2021 02:51:18 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 26 Oct 2021 02:51:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=jku4Xr
        LbEEhMjSTps/O6u2BzkibMZPGXPyKkKMINKds=; b=A0+oXMbYEy0rmrQrQNmyWz
        vBqHcKilmMB03El4KBY2s+idtp8S8TGXvpWs6mLZ3+YF85UQcY79tWW58I6gPM6M
        pkyRz6hP129IVAKzdUd7HE9I/pyjPIoR36aFvpbtuFuHD+CUfIuwWT6QrzQc7BJK
        b0zZs7xs5/hjQmVbZcLmfG11sfJsnTorUAWZmZA7+PWH0BIiTWnQT6ZoBIl5UFZh
        d0XYj189ozQDuV76s5yLrC+8weo/puB66/2D0gpy4hSFP0T30nIZXFui6Au5GYuK
        YydlR8R/dGQp4pGrJ7hy2VtZblQTUjjh+JWBkAvyxKtLgvcLtQlYvKF19lOjDPTA
        ==
X-ME-Sender: <xms:ZaV3YdnGWRfwzQ8O4CSoNAS8wrvgLowq3jvVIQvg2PJM0uqEdM-_Tw>
    <xme:ZaV3YY284l-mq1I45QgCVCc-ZwNTaUUwdFSg1mhslhrHVHuFgSH1nrPyP0HKfZiQ-
    2puNqCLTC2tlio>
X-ME-Received: <xmr:ZaV3YTpOTZiLaE1qeMpShwI_km1Lef4Brtn-U-09zaIrlX-L590OXRep1pK7mewCWAR3ZA7bFPVX3CNPNejmpV_G_no>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvdefiedguddtvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhepjedtteffheeihefhveffvddvieduhfegheefveffledvgffhleekuddtffel
    heefnecuffhomhgrihhnpehshiiikhgrlhhlvghrrdgrphhpshhpohhtrdgtohhmnecuve
    hluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghh
    sehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:ZaV3YdnWjfvMkPBP1_y4su9B3WXwznRE7DbDfvMiJzSMkTFeQzff0A>
    <xmx:ZaV3Yb00uwS1GWx2MVdtcjaNGKtjWPn8naPOg81tyCTdIDxtSywewQ>
    <xmx:ZaV3YcveOTrlQATnQplLzXRmaqfyPeUp4XTvUBchqQqOZQp31uIgSg>
    <xmx:ZqV3Yb_gxdWHjNWsE22rBvpzHo6FcS1_qrfVAwcprh2jayB7F1ZNnQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 26 Oct 2021 02:51:16 -0400 (EDT)
Date:   Tue, 26 Oct 2021 09:51:13 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        syzbot+93d5accfaefceedf43c1@syzkaller.appspotmail.com
Subject: Re: [PATCH net-next] netdevsim: Register and unregister devlink
 traps on probe/remove device
Message-ID: <YXelYVqeqyVJ5HLc@shredder>
References: <725e121f05362da4328dda08d5814211a0725dac.1635064599.git.leonro@nvidia.com>
 <YXUhyLXsc2egWNKx@shredder>
 <YXUtbOpjmmWr71dU@unreal>
 <YXU5+XLhQ9zkBGNY@shredder>
 <YXZB/3+IR6I0b2xE@unreal>
 <YXZl4Gmq6DYSdDM3@shredder>
 <YXaNUQv8RwDc0lif@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YXaNUQv8RwDc0lif@unreal>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 25, 2021 at 01:56:17PM +0300, Leon Romanovsky wrote:
> On Mon, Oct 25, 2021 at 11:08:00AM +0300, Ido Schimmel wrote:
> > On Mon, Oct 25, 2021 at 08:34:55AM +0300, Leon Romanovsky wrote:
> > > On Sun, Oct 24, 2021 at 01:48:25PM +0300, Ido Schimmel wrote:
> > > > On Sun, Oct 24, 2021 at 12:54:52PM +0300, Leon Romanovsky wrote:
> > > > > On Sun, Oct 24, 2021 at 12:05:12PM +0300, Ido Schimmel wrote:
> > > > > > On Sun, Oct 24, 2021 at 11:42:11AM +0300, Leon Romanovsky wrote:
> > > > > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > > > > > 
> > > > > > > Align netdevsim to be like all other physical devices that register and
> > > > > > > unregister devlink traps during their probe and removal respectively.
> > > > > > 
> > > > > > No, this is incorrect. Out of the three drivers that support both reload
> > > > > > and traps, both netdevsim and mlxsw unregister the traps during reload.
> > > > > > Here is another report from syzkaller about mlxsw [1].
> > > > > 
> > > > > Sorry, I overlooked it.
> > > > > 
> > > > > > 
> > > > > > Please revert both 22849b5ea595 ("devlink: Remove not-executed trap
> > > > > > policer notifications") and 8bbeed485823 ("devlink: Remove not-executed
> > > > > > trap group notifications").
> > > > > 
> > > > > However, before we rush and revert commit, can you please explain why
> > > > > current behavior to reregister traps on reload is correct?
> > > > > 
> > > > > I think that you are not changing traps during reload, so traps before
> > > > > reload will be the same as after reload, am I right?
> > > > 
> > > > During reload we tear down the entire driver and load it again. As part
> > > > of the reload_down() operation we tear down the various objects from
> > > > both devlink and the device (e.g., shared buffer, ports, traps, etc.).
> > > > As part of the reload_up() operation we issue a device reset and
> > > > register everything back.
> > > 
> > > This is an implementation which is arguably questionable and pinpoints
> > > problem with devlink reload. It mixes different SW layers into one big
> > > mess which I tried to untangle.
> > > 
> > > The devlink "feature" that driver reregisters itself again during execution
> > > of other user-visible devlink command can't be right design.
> > > 
> > > > 
> > > > While the list of objects doesn't change, their properties (e.g., shared
> > > > buffer size, trap action, policer rate) do change back to the default
> > > > after reload and we cannot go back on that as it's a user-visible
> > > > change.
> > > 
> > > I don't propose to go back, just prefer to see fixed mlxsw that
> > > shouldn't touch already created and registered objects from net/core/devlink.c.
> > > 
> > > All reset-to-default should be performed internally to the driver
> > > without any need to devlink_*_register() again, so we will be able to
> > > clean rest devlink notifications.
> > > 
> > > So at least for the netdevsim, this change looks like the correct one,
> > > while mlxsw should be fixed next.
> > 
> > No, it's not correct. After your patch, trap properties like action are
> > not set back to the default. Regardless of what you think is the "right
> > design", you cannot introduce such regressions.
> 
> Again, I'm not against fixing the regression, I'm trying to understand
> why it is impossible to fix mlxsw and netdevsim to honor SW layering
> properly.

devlink reload was implemented in 4.16 along with mlxsw support and from
day one it meant that devlink objects such as ports and shared buffer
were dynamically destroyed / created during reload. You cannot come
almost 4 years later, sprinkle assertions according to how you
implemented reload support and claim that the rest are wrong and need to
be fixed so that the assertions don't trigger.

Note that devlink reload is not the only command that can trigger the
destruction / creation of objects. devlink ports can also come and go
following split / unsplit commands.

> 
> > 
> > Calling devlink_*_unregister() in reload_down() and devlink_*_register()
> > in reload_up() is not new. It is done for multiple objects (e.g., ports,
> > regions, shared buffer, etc). After your patch, netdevsim is still doing
> > it.
> 
> Yeah, it was introduced by same developers who did it in mlxsw, so no
> wonders that same patterns exist in both drivers.

The point of netdevsim is to both provide a reference and allow
developers to test the code. If you bothered to run the tests under
tools/testing/selftests/drivers/net/netdevsim/ (or just instantiate /
reload netdevsim, really), these regressions [1][2] would have been
avoided. Instead, I need to ask you for the third time to revert the
changes.

[1] https://syzkaller.appspot.com/bug?id=c58973ab3345057753c9f629a88275e30ed2a370
[2] https://syzkaller.appspot.com/bug?extid=93d5accfaefceedf43c1

> 
> > 
> > Again, please revert the two commits I mentioned. If you think they are
> > necessary, you can re-submit them in the future, after proper review and
> > testing of the affected code paths.
> 
> It was posted for review in the ML, no one objected.

So what?

> 
> Can you please explain why is it so important to touch devlink SW
> objects, reallocate them again and again on every reload in mlxsw?

Because that's how reload was defined and implemented. A complete
reload. We are not changing the semantics 4 years later.
