Return-Path: <netdev+bounces-7316-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9482A71FA1C
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 08:29:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CF5811C20FD0
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 06:29:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 340374406;
	Fri,  2 Jun 2023 06:29:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 216F13FDB
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 06:29:27 +0000 (UTC)
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C300E10C9;
	Thu,  1 Jun 2023 23:28:59 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id 6a1803df08f44-62603efd2e3so14452386d6.1;
        Thu, 01 Jun 2023 23:28:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685687338; x=1688279338;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=JP4VtYfTpokhb/xoqxYleHsw/oeIF5+SRkQoPt6gSWw=;
        b=seMnMYJUUohGcgZxh2SIuvUdPt8SMK5RA3gNuvrselKQlYVOhKv4pU3ycWHlsk+3/r
         0ZQGY0GK/pqUZUNFChxO9qvZewXJvFFaWYEcbfYmM5//O9lIYWVYSv7oPslaT/ApWk1/
         ElaTo1UTp/x4JQnxxmBaAsndLnakR4WrNIEWT1/PIo6odpT7pq3qG2L7cC8OurUR8f3u
         Ff/9YMxyb0IEINcpvAIP++InRR60kAKP8ujup4pF5lztC97W4gb2R5rjapLGW4c5Uvuu
         5nTQN3ERO5vdNm5oExz7OIcI+utztZYlznaBrrE+somdPw6ZRkQ045BAYcx+xY+pJDgs
         ksTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685687338; x=1688279338;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JP4VtYfTpokhb/xoqxYleHsw/oeIF5+SRkQoPt6gSWw=;
        b=dvPhQzqPhc/eQUGKbGVjAofkb3sRYdtwO9+gGHA++i1kcs25f5jXAKWNfzSh8AjIzs
         v+h5EahmHfI2oLlzEfbs7/3oiwdWE6b49lMLZ0gDplqPiBLKJOoI+9T8UBI9gDobmsyq
         AiPPACvS9gmHdouhGpKkWf8FgtrvKqkbwle0CHGQTPjl1SMLg7ujm0+tw9FSxCCBf87w
         UCtPVX5Yl0V2y9moqeeToK3rfpTAcpjDU0eOah433A9EUImaTer/1nyZuC7xeDszlJOi
         D1zesvy4AZDDLW6NQ51Iu8cVImz8wZqNUDlaQrQfqaW+vN0my1phSRBy40WUl73eg/mf
         pG0A==
X-Gm-Message-State: AC+VfDzTShSWnh9D+nuvF+pa+NhGL35VLJV5ky0rQrUSxY2YBAW2skrm
	WJKoDGkBwVQE8jsTsFWpxeGsaOybtA6tO6Y/mhg=
X-Google-Smtp-Source: ACHHUZ4pCynEppFlR22bUG60ASi3Bp3h0SiDbE6Ea2qZiFI0YyRf6NsmTNQsSt6SWcwvtzWgdrHbW2oONDgFlWN2zPg=
X-Received: by 2002:a05:6214:411a:b0:621:1b73:52c9 with SMTP id
 kc26-20020a056214411a00b006211b7352c9mr11323635qvb.10.1685687338157; Thu, 01
 Jun 2023 23:28:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230601070058.2117-1-eggcar.luan@gmail.com> <CO1PR11MB5089465F5D37EBA62BB1A123D6499@CO1PR11MB5089.namprd11.prod.outlook.com>
 <22e193f7-b55d-a31a-0179-4a53af692a89@intel.com>
In-Reply-To: <22e193f7-b55d-a31a-0179-4a53af692a89@intel.com>
From: egg car <eggcar.luan@gmail.com>
Date: Fri, 2 Jun 2023 14:28:47 +0800
Message-ID: <CACMC4jYdZjLKOLW0gFMOwwH-6bjGW1cBroXe6pioh+w4JQa9Bw@mail.gmail.com>
Subject: Re: [PATCH v2] igb: Fix extts capture value format for 82580/i354/i350
To: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: "Keller, Jacob E" <jacob.e.keller@intel.com>, 
	"Brandeburg, Jesse" <jesse.brandeburg@intel.com>, "davem@davemloft.net" <davem@davemloft.net>, 
	"edumazet@google.com" <edumazet@google.com>, "kuba@kernel.org" <kuba@kernel.org>, 
	"pabeni@redhat.com" <pabeni@redhat.com>, 
	"intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>, 
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Dear Tony and Jacob,

Thanks for the review, I'll optimize the patch soon.

Regards,
Yuezhen Luan

