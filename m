Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF847D06D
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 00:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730877AbfGaWCv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 18:02:51 -0400
Received: from mail-qk1-f178.google.com ([209.85.222.178]:38688 "EHLO
        mail-qk1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729021AbfGaWCv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 18:02:51 -0400
Received: by mail-qk1-f178.google.com with SMTP id a27so50428256qkk.5
        for <netdev@vger.kernel.org>; Wed, 31 Jul 2019 15:02:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=lhmdHZoJeXaoILt2I/N7FFowbRa/64fHD+ZZ2SBFD4s=;
        b=VHAx5Mf3jTchN1vXII1nlV9niEbYmh+8VXKoiPV6XmTSxV0d9NhXrjAktooILYZJlD
         A8BZ6ne1d3v3uNpScpgGWfDiASwlry42m6H0wZrNTzieI5tdPNAhgvFImkLXZ8WG91nh
         qHpO61U2AYPNtStqgyX9eJGYNluC0GK2NwWHgFouAUKwWVRu9rwqs0BJw/+H0QaCxJuL
         so+Hu1DtpMV2PKQJyk3jobdeTEQ001qWyaYc2/RwbzlyYiKee/qZObqnX++mTIDrfA5E
         PFo2MhcaDi+aU9YdXfRiuY6kDisWBs18gIKJWdly3BP0Te3Q1T6DW7zTrISqWML6vzMY
         EZcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=lhmdHZoJeXaoILt2I/N7FFowbRa/64fHD+ZZ2SBFD4s=;
        b=XDYEoEU+XLP/DDmUipeYrCxkQmX8CNEA35TiIPY/De1Z0AMg3y3N3NH7smT3edjJEV
         evvHF+EbW+nvZCmisVUi4W5/kx+d3HHjTfVXTatNlRTGrkF+3a9ID26w0Les9pDJTYlR
         gKV4ne/mQ3UK9Ld8HSCzD3MCa2XUE6c+iu/mENYUs2DbJ+7x9WxWYBuUCtHLBx3SIMdd
         rBukTuyZASoN0Cf6fLoEFrmMiq4hvyJSa+1jjdDJK0leXA32CUpMzMQSWdBJoRY5arjP
         nMP0j/wRV32Rqj1jr0vJaTSLiVLa24K7lNZk7U5KPnS+2lVeni57bPp5Rhbv8CmMuMRC
         o8RA==
X-Gm-Message-State: APjAAAVP1w9gBqsX6Q037wv01ZmhBNOI10fqx6m/tWRl+1XwjjK/BRFX
        UFOaoqxKVvWMfm237ZVBX7YZIQ==
X-Google-Smtp-Source: APXvYqz+fpcolFj9GD/TB5caXR/O7S7FTu9JCcq3gTB6w0rXdFWhBLaBsdCYYXCUzkiTQCIzVgR/uw==
X-Received: by 2002:a05:620a:1506:: with SMTP id i6mr82925539qkk.346.1564610569651;
        Wed, 31 Jul 2019 15:02:49 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id x10sm27367048qtc.34.2019.07.31.15.02.48
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 31 Jul 2019 15:02:49 -0700 (PDT)
Date:   Wed, 31 Jul 2019 15:02:33 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        davem@davemloft.net, sthemmin@microsoft.com, mlxsw@mellanox.com
Subject: Re: [patch net-next 0/3] net: devlink: Finish network namespace
 support
Message-ID: <20190731150233.432d3c86@cakuba.netronome.com>
In-Reply-To: <8f5afc58-1cbc-9e9a-aa15-94d1bafcda22@gmail.com>
References: <20190727094459.26345-1-jiri@resnulli.us>
        <eebd6bc7-6466-2c93-4077-72a39f3b8596@gmail.com>
        <20190730060817.GD2312@nanopsycho.orion>
        <8f5afc58-1cbc-9e9a-aa15-94d1bafcda22@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 31 Jul 2019 15:50:26 -0600, David Ahern wrote:
> On 7/30/19 12:08 AM, Jiri Pirko wrote:
> > Mon, Jul 29, 2019 at 10:17:25PM CEST, dsahern@gmail.com wrote:  
> >> On 7/27/19 3:44 AM, Jiri Pirko wrote:  
> >>> From: Jiri Pirko <jiri@mellanox.com>
> >>>
> >>> Devlink from the beginning counts with network namespaces, but the
> >>> instances has been fixed to init_net. The first patch allows user
> >>> to move existing devlink instances into namespaces:
> >>>  
> >>
> >> so you intend for an asic, for example, to have multiple devlink
> >> instances where each instance governs a set of related ports (e.g.,
> >> ports that share a set of hardware resources) and those instances can be
> >> managed from distinct network namespaces?  
> > 
> > No, no multiple devlink instances for asic intended.  
> 
> So it should be allowed for an asic to have resources split across
> network namespaces. e.g., something like this:
> 
>    namespace 1 |  namespace 2  | ... | namespace N
>                |               |     |
>   { ports 1 }  |   { ports 2 } | ... | { ports N }
>                |               |     |
>    devlink 1   |    devlink 2  | ... |  devlink N
>   =================================================
>                    driver

Can you elaborate further? Ports for most purposes are represented by
netdevices. Devlink port instances expose global topological view of
the ports which is primarily relevant if you can see the entire ASIC.
I think the global configuration and global view of resources is still
the most relevant need, so in your diagram you must account for some
"all-seeing" instance, e.g.:

   namespace 1 |  namespace 2  | ... | namespace N
               |               |     |
  { ports 1 }  |   { ports 2 } | ... | { ports N }
               |               |     |
subdevlink 1   | subdevlink 2  | ... |  subdevlink N
         \______      |              _______/
                 master ASIC devlink
  =================================================
                   driver

No?
