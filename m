Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDDE56D1AFE
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 10:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231277AbjCaI65 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 04:58:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbjCaI6z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 04:58:55 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 232EC1BF4A;
        Fri, 31 Mar 2023 01:58:45 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id x3so86820484edb.10;
        Fri, 31 Mar 2023 01:58:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680253123;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BYgdpbZjRcMBBZb2pcPFoHc8NfA9uoYOg/WF0eXftpw=;
        b=lVKy9HSAOGeFLg+iy7ujKGiGribkgannSjZw89QjDiPB0ZV6BZm9+DizSMM+gX3jEw
         8QIkoiOy2MNkxNZZupbYDoc64yJzb7Zakr4oYn+NZsqx23cfATRwfdyLTql0+IM3dC5T
         9zKB3+Y68Ext8eXLKbm+4W1Mq+WMbsW3LTUkmel8sWJCt88C13fN9xBBvjtKqUosu9Gw
         ucQZhXb/e9f0vPsnfBcOSdQNwVW3hXH1vRu0z/fas0JuC3+hUy/k1KwL7H5IS5+eme+q
         lWNM6p5ohWlyVrBT/8KIVW5ZPpOmzUu9j6j2ZOXYo+84gdkfqnAmrpw7d0uQRaY9JwTf
         NIdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680253123;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BYgdpbZjRcMBBZb2pcPFoHc8NfA9uoYOg/WF0eXftpw=;
        b=OSkhwpU5xNakr9xCYuIrglwEwN5p4VsDDo8MRymLVUIM7P2RWufwIOxd/VUsRS9kRh
         CZViN5tdFJ46uzIXacFDgokhaak9VYjX03eQs4alApJf/3rhvtY0Ee4/geSztTH9hq4f
         yt6kznPOj5cYaQurGyV/4D0wXLvoRijClN6tyOLvIzp3XkHaxuspXI1SNR5DdHGt+z+i
         eSMBbYBDF9m2W3tXIZPaacx4v/VMaBLepRG+qt1kn7QJTqxZ8uNcRE/vMTsbsuIrFYL+
         PBHQVAi5IDTsZTAAvpYX1tymc75jSmVCmTKCVJ9adISL1psG0PK9JRPIdZ6H1MCcayBb
         cVEg==
X-Gm-Message-State: AAQBX9fiykmWipEs0X8OE4D0N6KKXC4mpCBRegPsWq7NBLyC4644ZA5S
        PeQIgPyDh6J64iIws/ugmGI=
X-Google-Smtp-Source: AKy350aDaFJSJOJ7Uru86M1OtrOcJd6vzXZMOua1Cw1Olv1RS4PYAfP4YNznT2gZtEmV3ghHrGPU/g==
X-Received: by 2002:a17:906:71d7:b0:8a6:5720:9101 with SMTP id i23-20020a17090671d700b008a657209101mr27504694ejk.4.1680253123346;
        Fri, 31 Mar 2023 01:58:43 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id x2-20020a170906296200b0092421bf4927sm764255ejd.95.2023.03.31.01.58.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 01:58:43 -0700 (PDT)
Date:   Fri, 31 Mar 2023 11:58:40 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Hans Schultz <netdev@kapio-technology.com>
Cc:     Ido Schimmel <idosch@nvidia.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        "maintainer:MICROCHIP KSZ SERIES ETHERNET SWITCH DRIVER" 
        <UNGLinuxDriver@microchip.com>, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        "open list:RENESAS RZ/N1 A5PSW SWITCH DRIVER" 
        <linux-renesas-soc@vger.kernel.org>,
        "moderated list:ETHERNET BRIDGE" <bridge@lists.linux-foundation.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH v2 net-next 6/6] selftests: forwarding: add dynamic FDB
 test
Message-ID: <20230331085840.5wfxsuj6u7hge2uj@skbuf>
References: <20230318141010.513424-1-netdev@kapio-technology.com>
 <20230318141010.513424-7-netdev@kapio-technology.com>
 <ZBgdAo8mxwnl+pEE@shredder>
 <87a5zzh65p.fsf@kapio-technology.com>
 <ZCMYbRqd+qZaiHfu@shredder>
 <874jq22h2u.fsf@kapio-technology.com>
 <20230330192714.oqosvifrftirshej@skbuf>
 <874jq1mkm1.fsf@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874jq1mkm1.fsf@kapio-technology.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 31, 2023 at 09:43:34AM +0200, Hans Schultz wrote:
> On Thu, Mar 30, 2023 at 22:27, Vladimir Oltean <olteanv@gmail.com> wrote:
> > This is how I always run them, and it worked fine with both Debian
> > (where it's easy to add missing packages to the rootfs) or with a more
> > embedded-oriented Buildroot.
> 
> I am not entirely clear of your idea. You need somehow to boot into a
> system with the patched net-next kernel

You have to do that anyway for any kind of kernel work, no?

> or you have a virtual machine boot into a virtual OS. I guess it is
> the last option you refer to using Debian?

You could do that too, but you don't have to. Debian, like many other
Linux distributions, supports a wide variety of CPU architectures; it
can be run on embedded systems just as well as on desktop PCs or VMs.
I didn't say you have to use Debian, though, I just said I ran the
selftests on a Debian-based rootfs and that it was easy to prepare the
environment there. The Debian rootfs and the selftests were deployed to
the target board with the DSA switch on it, in case that wasn't clear.
