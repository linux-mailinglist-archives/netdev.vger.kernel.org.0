Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2F456EB51E
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 00:44:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233904AbjDUWoK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 18:44:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233627AbjDUWoJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 18:44:09 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB9EC1FDF
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 15:44:07 -0700 (PDT)
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 685654131D
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 22:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1682116461;
        bh=Sj3MF9YcERUJ/RxGSVvvZ5YjyKguaHlEISQ7ZOZ2kTk=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=iyxWtoIJZ7dGvTUiRt9yS+k/Nv3J2HY7gvAnkIYsUKTkpdWlBwBridDu+UO0fPK85
         7q6QK32WKKJS2pte4AnBFuTWPcKRiCcn6Haa3rHKiUUfwct2ZU8DD44Z0NVvR/zw3L
         u9YfFCKiMy1dTtvXiIwEj1fC0VeCy6Z9dzx1m8e2Ciz6CvuFj8+oLcT4KczSb6qpgp
         0cFPXL29J59tNt0u2ajVps/CK7RDxc8IgU3EoDlVufaqwB3h4FT3G4JahszCNg/jYJ
         LjEoVOQS3AX6BSZMQsLg/HhtBIMLfgVzdATbCxWurk5qy9EA8VWk3AByguDT/lXnmn
         eGJPuWLwr7ICg==
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-1a697b64beaso17281325ad.1
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 15:34:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682116460; x=1684708460;
        h=message-id:date:content-transfer-encoding:content-id:mime-version
         :comments:references:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Sj3MF9YcERUJ/RxGSVvvZ5YjyKguaHlEISQ7ZOZ2kTk=;
        b=MR515XjbVNw6XFo3aY0J4v9tbIbZMobu6SltZKJdWNbk0KYV641IKnO49beYUwCJ1q
         MYvqGxtSMxIb1Zujr8pCqCngeSantKkel5aTnMaT7a7KA0+OOVzd9RAmQsMi3WVufuAJ
         fEjbbAlOVWHyh8YtCo4jtqlzhFjbF/0zlcTTEWww35yMpgpOLhycp1ay9UtUTVFYnmnP
         Oh6/1unO8SnQ1YigJlr0hRgLcGNBeWjC+Ea+2Mp5U+uMRSFocRNChOo+q+uADJ+Ko9oE
         vJGENNQytcOZe2sd10xWHmBLU87/04M9na/8TO8l/Pm9OPUkAv1277m3BVlAXtrPvgD+
         JT0Q==
X-Gm-Message-State: AAQBX9dCvpZh/WOCu3TdaUJi1Py6XU+1B13exgBPrxKHMbeUzwNlgL1Y
        97ovbUkapYL7OYlSstKxa1fQLcq8EKuOl+MXyICzFO9pgRy+S0t7bvSbY0PluCoOb5McJzcYhaZ
        hrG5Qw2XnVaSeCvpaUaLk5YWuiXNtioGOlw==
X-Received: by 2002:a17:903:120b:b0:1a5:2db2:2bb with SMTP id l11-20020a170903120b00b001a52db202bbmr8264863plh.15.1682116459871;
        Fri, 21 Apr 2023 15:34:19 -0700 (PDT)
X-Google-Smtp-Source: AKy350YVqzce5ua6oMEIHpzB5BIHDBQYR5OTTZyFmBGbAOjevPaWyXQkYrLBw0OkLnWo1SvKFxTBZA==
X-Received: by 2002:a17:903:120b:b0:1a5:2db2:2bb with SMTP id l11-20020a170903120b00b001a52db202bbmr8264848plh.15.1682116459546;
        Fri, 21 Apr 2023 15:34:19 -0700 (PDT)
Received: from famine.localdomain ([50.125.80.253])
        by smtp.gmail.com with ESMTPSA id t3-20020a17090a950300b0024796ddd19bsm4941699pjo.7.2023.04.21.15.34.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Apr 2023 15:34:19 -0700 (PDT)
Received: by famine.localdomain (Postfix, from userid 1000)
        id 741FA607E6; Fri, 21 Apr 2023 15:34:18 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 6BF799FB79;
        Fri, 21 Apr 2023 15:34:18 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Vladimir Oltean <olteanv@gmail.com>
cc:     Simon Horman <horms@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Andy Gospodarek <andy@greyhouse.net>, netdev@vger.kernel.org
Subject: Re: [PATCH] bonding: Always assign be16 value to vlan_proto
In-reply-to: <20230421091737.deetnyj6cakrn3mg@skbuf>
References: <20230420-bonding-be-vlan-proto-v1-1-754399f51d01@kernel.org> <9836.1682020053@famine> <20230420202303.iecl2vnkbdm2qfs7@skbuf> <16322.1682025812@famine> <ZEI0zpDyJtfogO7s@kernel.org> <20230421091737.deetnyj6cakrn3mg@skbuf>
Comments: In-reply-to Vladimir Oltean <olteanv@gmail.com>
   message dated "Fri, 21 Apr 2023 12:17:37 +0300."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <29610.1682116458.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Fri, 21 Apr 2023 15:34:18 -0700
Message-ID: <29611.1682116458@famine>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir Oltean <olteanv@gmail.com> wrote:

>On Fri, Apr 21, 2023 at 09:01:34AM +0200, Simon Horman wrote:
>> Hi Jay and Vladimir,
>> =

>> Thanks for your review.
>> =

>> Firstly, sorry for the distraction about the VLAN_N_VID math.  I agree =
it
>> was incorrect. I had an out by one bug in my thought process which was
>> about 0x0fff instead of 0x1000.
>> =

>> Secondly, sorry for missing the central issue that it is a bit weird
>> to use a VID related value as a sentinel for a protocol field.
>> I agree it would be best to chose a different value.
>> =

>> In reference to the list of EtherTypes [1]. I think 0 might be ok,
>> but perhaps not ideal as technically it means a value of 0 for the
>> IEEE802.3 Length Field (although perhaps it can never mean that in this
>> context).
>> =

>> OTOH, 0xffff, is 'reserved' ([1] references RFC1701 [2]),
>> so perhaps it is a good choice.
>> =

>> In any case, I'm open to suggestions.
>> I'll probably hold off until the v6.5 cycle before reposting,
>> unless -rc8 appears next week. I'd rather not rush this one
>> given that I seem to have already got it wrong once.
>> =

>> [1] https://www.iana.org/assignments/ieee-802-numbers/ieee-802-numbers.=
xhtml#ieee-802-numbers-1
>> [2] https://www.rfc-editor.org/rfc/rfc1701.html
>
>Any value would work as long as it's not a valid VLAN protocol.
>I would #define BOND_VLAN_PROTO_NONE htons(0xffff) and use that.

	All of the above is fine with me; this isn't an urgent change.

	-J

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
