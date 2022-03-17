Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E2844DC93B
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 15:50:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235351AbiCQOvt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 10:51:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235152AbiCQOvs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 10:51:48 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD45920214F;
        Thu, 17 Mar 2022 07:50:31 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id 25so7524423ljv.10;
        Thu, 17 Mar 2022 07:50:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=a1deU4EzeQc2joaO/0pAzd9yMJPMyBOx4cFep+UZqpU=;
        b=grrSiCZnED0iRJVv3x8DdKEd2SBdCYYEKvx78/W0bwwg6lNgPAwknPtj4c6HaqI+EB
         VZs4aVLKZIGpaopOl4oa9mXcGDZjPzf1yTo5p0EmoAYBo/s3qCpBLinPtdu3E6eGqBMb
         BeMNwzdrmDCinI9oocmQ5z5nhtlFXBeyLEDAN8X9j3/B9X7tOU2M4rO8llre/dB5Sq+1
         KlypWQFtEU1f3jxAFhUeICPh+WHp4WY2F4N17BPjz4AFxSx392cLPRuBgS1/6ir8D+5q
         pacdrxhFJUnthnPVsdra+8yLjOibVEBRoaxMPkokjOHAwNvP5aQuAOqkdbQulW94i2rb
         JeAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=a1deU4EzeQc2joaO/0pAzd9yMJPMyBOx4cFep+UZqpU=;
        b=tFIY/mnP7aDXrjndYVEECz+98mrOwpmbjNruNHQT3xGAql8wKuNzOvv5bM7gxXCfpw
         C+d+BIgFAjY41UzNDS0908V3mARdLlQCy2DdGC4PDZpj/wNfEv+Putv8WbpUQu2wUfv4
         N8Utdep9bPe+DOygpDgvvKkZTgAX1ARXtPKYav/VJA6J0Fv0w/QgqOwbQJOTPwtNoVKS
         kbpephRx82LSx2hwz/LgjBk22v5m9LN+2nsEwNvuHlQC5a6mmCxIjSESDGKO0J+ofiL5
         rjrqfGxIzWX0NOnIbBA6yyC8pwsG3Le8u5WcFuIzr05Ux4JlbxslhHRJfr+v1JYZR7ye
         Dz5A==
X-Gm-Message-State: AOAM531LmuA8jajHRnOZ09+6CD3Fh+tj8Z8x21T56z5Q439cL8+xpQph
        o+QYXKZRrSxoLvZDYabCOX3zIwygHRJT/g==
X-Google-Smtp-Source: ABdhPJwNNENC86ntj9Bj44eTnnIs1ropK1IquslMLjtqZZuQXlzZ7Lk2v+RfqJm9d5uJs6CT7C21DA==
X-Received: by 2002:a2e:9d43:0:b0:249:4022:dd32 with SMTP id y3-20020a2e9d43000000b002494022dd32mr3101119ljj.235.1647528630053;
        Thu, 17 Mar 2022 07:50:30 -0700 (PDT)
Received: from wse-c0127 ([208.127.141.29])
        by smtp.gmail.com with ESMTPSA id k5-20020a2e2405000000b0024801a68041sm449691ljk.128.2022.03.17.07.50.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Mar 2022 07:50:29 -0700 (PDT)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     Ido Schimmel <idosch@idosch.org>,
        Hans Schultz <schultz.hans@gmail.com>, razor@blackwall.org
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 net-next 1/4] net: bridge: add fdb flag to extent
 locked port feature
In-Reply-To: <YjM7Iwx4MDdGEHFA@shredder>
References: <20220317093902.1305816-1-schultz.hans+netdev@gmail.com>
 <20220317093902.1305816-2-schultz.hans+netdev@gmail.com>
 <YjM7Iwx4MDdGEHFA@shredder>
Date:   Thu, 17 Mar 2022 15:50:26 +0100
Message-ID: <86ilsciqfh.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On tor, mar 17, 2022 at 15:44, Ido Schimmel <idosch@idosch.org> wrote:
> On Thu, Mar 17, 2022 at 10:38:59AM +0100, Hans Schultz wrote:
>> Add an intermediate state for clients behind a locked port to allow for
>> possible opening of the port for said clients. This feature corresponds
>> to the Mac-Auth and MAC Authentication Bypass (MAB) named features. The
>> latter defined by Cisco.
>> Only the kernel can set this FDB entry flag, while userspace can read
>> the flag and remove it by deleting the FDB entry.
>
> Can you explain where this flag is rejected by the kernel?
>
Is it an effort to set the flag from iproute2 on adding a fdb entry?

> Nik, it seems the bridge ignores 'NDA_FLAGS_EXT', but I think that for
> new flags we should do a better job and reject unsupported
> configurations. WDYT?
>
> The neighbour code will correctly reject the new flag due to
> 'NTF_EXT_MASK'.
