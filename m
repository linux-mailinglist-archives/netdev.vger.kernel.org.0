Return-Path: <netdev+bounces-4347-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D975070C26D
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 17:32:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 945AC280FCA
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 15:32:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE70514AB9;
	Mon, 22 May 2023 15:32:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C33DC14AAA
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 15:32:20 +0000 (UTC)
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FEDDBB
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 08:32:19 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id 41be03b00d2f7-5289cf35eeaso2515715a12.1
        for <netdev@vger.kernel.org>; Mon, 22 May 2023 08:32:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1684769539; x=1687361539;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n/OGvTzar0UeMVbP+tFQM4FnjSesRCrqPLNsxriBQ8Q=;
        b=eoyVSdI4m91V0B5QfINnqlHJs//p7SfKX/GeFZ+UMgH72hq/lJR+9OqrI0faUNIQQN
         pDQZ/H7wjcns007pZ3lu9StWVKr0Ri8+QVbukuLbYUbnnsoidfUrcGqFZQAnWyOl4EJB
         2jZWcUwUvosTGnkOXdQgFOs1GcjoYOoErqDxDzmgooYzrOaJvbViarHQfD+Zip+20Grq
         hGEk0NnLCi1HwKf9JCaZUbUtIATnlZB15UMi00CijV/9E0+YTBhyndq3iq9C7tTw3G3+
         2hmFsyxZQkkxtbK211xyyG/ZVtqMXrATYHzQCSqVd6DKvvUiccgDVLmvc7LOmbJAYbb+
         m+hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684769539; x=1687361539;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n/OGvTzar0UeMVbP+tFQM4FnjSesRCrqPLNsxriBQ8Q=;
        b=R9IzBQuByIX7AVsAQ32UhUCi78Mx3OJGXq+7wRYdY0giIMWFaiPnf3OhL3qfVz9xxL
         sF0ZmKqZYh/jsbIe/sOWMe3ACBG922Ly0MKRKLM6rxGpwAwKMgOPJVvNVJpx8yM0JXLY
         x/8+Gk7y2FNzbL4HVuZfS9IImiGZaOVU7gKzkVPtI7OcD3StmmPGM9jbI+8wl820IrUD
         FpEHWQqivWgsqKS/Esj7lx0PSsMbGCzdIicun+IoMtK5mTVTfrct9tOrI+lgS4fcinb3
         jsxEfhsva90ygbNfPrugDTrDzwo4Cj+2h4oSxFaA37a29gf8CyoC9wG9coXVx8Aqp53J
         P7ag==
X-Gm-Message-State: AC+VfDwa6406aBv44ycUvAfqlxn00ZYzAPiBzrCokVlSGMhTcEsJ72uc
	ekMeO8vUltbBuCErnLTtAux9RQ==
X-Google-Smtp-Source: ACHHUZ7hDrVf9RZZvp8MVrS+aKyOosHrK4mNQWyWG6rxp/VCdDRWkV/vtG9EFnPQwqk21eiX/S6qiw==
X-Received: by 2002:a17:90a:b902:b0:24e:201e:dcbd with SMTP id p2-20020a17090ab90200b0024e201edcbdmr11723073pjr.21.1684769538787;
        Mon, 22 May 2023 08:32:18 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id q35-20020a17090a17a600b002502161b063sm6508098pja.54.2023.05.22.08.32.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 08:32:18 -0700 (PDT)
Date: Mon, 22 May 2023 08:32:16 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Ido Schimmel <idosch@idosch.org>
Cc: Vladimir Nikishkin <vladimir@nikishkin.pw>, dsahern@gmail.com,
 netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, eng.alaamohamedsoliman.am@gmail.com,
 gnault@redhat.com, razor@blackwall.org, idosch@nvidia.com,
 liuhangbin@gmail.com, eyal.birger@gmail.com, jtoppins@redhat.com
Subject: Re: [PATCH iproute2-next v5] ip-link: add support for nolocalbypass
 in vxlan
Message-ID: <20230522083216.09cc8fd7@hermes.local>
In-Reply-To: <ZGsIhkGT4RBUTS+F@shredder>
References: <20230521054948.22753-1-vladimir@nikishkin.pw>
	<ZGpvrV4FGjBvqVjg@shredder>
	<20230521124741.3bb2904c@hermes.local>
	<ZGsIhkGT4RBUTS+F@shredder>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, 22 May 2023 09:15:34 +0300
Ido Schimmel <idosch@idosch.org> wrote:

> On Sun, May 21, 2023 at 12:47:41PM -0700, Stephen Hemminger wrote:
> > On Sun, 21 May 2023 22:23:25 +0300
> > Ido Schimmel <idosch@idosch.org> wrote:
> >   
> > > +       if (tb[IFLA_VXLAN_LOCALBYPASS])
> > > +               print_bool(PRINT_ANY, "localbypass", "localbypass ",
> > > +                          rta_getattr_u8(tb[IFLA_VXLAN_LOCALBYPASS]))  
> > 
> > That will not work for non json case.  It will print localbypass whether it is set or not.
> > The third argument is a format string used in the print routine.  
> 
> Yea, replied too late...
> 
> Anyway, my main problem is with the JSON output. Looking at other
> boolean VXLAN options, we have at least 3 different formats:
> 
> 1. Only print when "true" for both JSON and non-JSON output. Used for
> "external", "vnifilter", "proxy", "rsc", "l2miss", "l3miss",
> "remcsum_tx", "remcsum_rx".
> 
> 2. Print when both "true" and "false" for both JSON and non-JSON output.
> Used for "udp_csum", "udp_zero_csum6_tx", "udp_zero_csum6_rx".
> 
> 3. Print JSON when both "true" and "false" and non-JSON only when
> "false". Used for "learning".
> 
> I don't think we should be adding another format. We need to decide:
> 
> 1. What is the canonical format going forward?
> 
> 2. Do we change the format of existing options?
> 
> My preference is:
> 
> 1. Format 2. Can be implemented in a common helper used for all VXLAN
> options.
> 
> 2. Yes. It makes all the boolean options consistent and avoids future
> discussions such as this where a random option is used for a new option.

A fourth option is to us print_null(). The term null is confusing and people
seem to avoid it.  But it is often used by python programmers as way to represent
options. That would be my preferred option but others seem to disagree.

Option #2 is no good. Any printing of true/false in non-JSON output is a diveregence
from the most common practice across iproute2.

That leaves #3 as the correct and best output.

FYI - The iproute2 maintainers are David Ahern and me. The kernel bits have
other subsystem maintainers.

