Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ED8859044B
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 18:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236195AbiHKQq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 12:46:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239149AbiHKQpm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 12:45:42 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81039ABF19
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 09:18:05 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id c11-20020a170902d48b00b0016f093907e0so11728199plg.20
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 09:18:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=w9Ubj4OzQE3ffMJ/ARoQJkMO4sXqU3QEFZeRKMDqfuE=;
        b=W6GJeuyn1ZH+lJBMHsxHi7YDg2XSAeICOOEoarWYx6dIbRxUlIeGTIa235maADZM42
         fTOvWxQxHW6yQKkPUzfUQyk6dZOUSAMViCJ5hyDSK5GrIDuAWGL2tW7C8/+uZsFjgKRO
         0cdOd3YN91KjK9yG65Ozuu0lVk8T4RcJDBRvkTrg2EOMic+w9fEvdmRzegM8oi85E5MQ
         bloSXxagk+yHlddzVS9gfLFugz4ETMwvCJznChe5iLhZfom4ZCxCoyQJLvFFGfcLyPr1
         D2fNk9HdqBStYSqSFf93swd5qr3cdh5PCXcZYAKxcqELok+7LTSCzXls3y4nkJoY7jt9
         8rrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=w9Ubj4OzQE3ffMJ/ARoQJkMO4sXqU3QEFZeRKMDqfuE=;
        b=TaTvlfV1G6OOmJUfDY1KWYhPGH7eEGs8gO2Ct/hjY2AcP5B1uNvgl+2IipUAusIlAH
         eXUePmmQ26ki2dHRgBJHXnzgUrlEoAWUpwxH/nrPmrRZ6b7WPOlN+UD/9rTEWIG8Gnew
         QO1jBWn4/wn5q6BwWLSaBSTSfSRJ535kSTz3PGbU3Vuu5R/2ZHksbjFAs78lZxfTd92e
         PHCbqWJ8sJiUDSztM0eKUp58lO1r/dgk+hZqQBm51LiTrbogS2Xi/Sf+lCtglRbh6zXv
         Zd7g42z9RyGeoeNRJh2Nk61k1bKVF4qdm+xyodclDoKllAVJuz8OTUq4mlC+dopDqYsq
         1GKg==
X-Gm-Message-State: ACgBeo3iB0ArMg36CrINLpOAtLO3jGoB/SokmbfRXulxnb6jRM0d6Nfq
        fnQ/uJ/ux9Q329oQ3eSWVoXuu2E=
X-Google-Smtp-Source: AA6agR7Sdkb59bDlRsAbfQrkFRNJBe/8uAs4cN1bJdBWU44UnvkeaDGQ6QXMhOdb+AuqnaDLby8Ewpc=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:902:e88a:b0:16f:281:3f59 with SMTP id
 w10-20020a170902e88a00b0016f02813f59mr32963781plg.0.1660234685002; Thu, 11
 Aug 2022 09:18:05 -0700 (PDT)
Date:   Thu, 11 Aug 2022 09:18:03 -0700
In-Reply-To: <20220811022304.583300-5-kuba@kernel.org>
Message-Id: <YvUru3QvN/LuYgnq@google.com>
Mime-Version: 1.0
References: <20220811022304.583300-1-kuba@kernel.org> <20220811022304.583300-5-kuba@kernel.org>
Subject: Re: [RFC net-next 4/4] ynl: add a sample user for ethtool
From:   sdf@google.com
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com, vadfed@fb.com,
        johannes@sipsolutions.net, jiri@resnulli.us, dsahern@kernel.org,
        stephen@networkplumber.org, fw@strlen.de, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/10, Jakub Kicinski wrote:
> A sample schema describing ethtool channels and a script showing
> that it works. The script is called like this:

>   ./tools/net/ynl/samples/ethtool.py \
>      --spec Documentation/netlink/bindings/ethtool.yaml \
>      --device eth0

> I have schemas for genetlink, FOU and the proposed DPLL subsystem,
> to validate that the concept has wide applicability, but ethtool
> feels like the best demo of the 4.

Looks super promising! I'm going to comment mostly here because it's easier
to talk about the sample schema definition.

> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>   Documentation/netlink/bindings/ethtool.yaml | 115 ++++++++++++++++++++
>   tools/net/ynl/samples/ethtool.py            |  30 +++++
>   2 files changed, 145 insertions(+)
>   create mode 100644 Documentation/netlink/bindings/ethtool.yaml
>   create mode 100755 tools/net/ynl/samples/ethtool.py

> diff --git a/Documentation/netlink/bindings/ethtool.yaml  
> b/Documentation/netlink/bindings/ethtool.yaml
> new file mode 100644
> index 000000000000..b4540d60b4b3
> --- /dev/null
> +++ b/Documentation/netlink/bindings/ethtool.yaml
> @@ -0,0 +1,115 @@
> +# SPDX-License-Identifier: BSD-3-Clause
> +
> +name: ethtool
> +
> +description: |
> +  Ethernet device configuration interface.
> +

[..]

> +attr-cnt-suffix: CNT

Is it a hack to make the generated header fit into existing
implementation? Should we #define ETHTOOL_XXX_CNT ETHTOOL_XXX in
the implementation instead? (or s/ETHTOOL_XXX_CNT/ETHTOOL_XXX/ the
source itself?)

> +attribute-spaces:

Are you open to bike shedding? :-) I like how ethtool_netlink.h calls
these 'message types'.

> +  -
> +    name: header
> +    name-prefix: ETHTOOL_A_HEADER_

Any issue with name-prefix+name-suffix being non-greppable? Have you tried
something like this instead:

- name: ETHTOOL_A_HEADER # this is fake, for ynl reference only
   attributes:
     - name: ETHTOOL_A_HEADER_DEV_INDEX
       val:
       type:
     - name ETHTOOL_A_HEADER_DEV_NAME
       ..

It seems a bit easier to map the spec into what it's going to produce.
For example, it took me a while to translate 'channels_get' below into
ETHTOOL_MSG_CHANNELS_GET.

Or is it too much ETHTOOL_A_HEADER_?

> +    attributes:
> +      -
> +        name: dev_index
> +        val: 1
> +        type: u32
> +      -
> +        name: dev_name
> +        type: nul-string

[..]

> +        len: ALTIFNAMSIZ - 1

Not sure how strict you want to be here. ALTIFNAMSIZ is defined
somewhere else it seems? (IOW, do we want to have implicit dependencies
on external/uapi headers?)

> +      -
> +        name: flags
> +        type: u32
> +  -
> +    name: channels
> +    name-prefix: ETHTOOL_A_CHANNELS_
> +    attributes:
> +      -
> +        name: header
> +        val: 1
> +        type: nest
> +        nested-attributes: header
> +      -
> +        name: rx_max
> +        type: u32
> +      -
> +        name: tx_max
> +        type: u32
> +      -
> +        name: other_max
> +        type: u32
> +      -
> +        name: combined_max
> +        type: u32
> +      -
> +        name: rx_count
> +        type: u32
> +      -
> +        name: tx_count
> +        type: u32
> +      -
> +        name: other_count
> +        type: u32
> +      -
> +        name: combined_count
> +        type: u32
> +
> +headers:
> +  user: linux/if.h
> +  uapi: linux/ethtool_netlink.h
> +
> +operations:
> +  name-prefix: ETHTOOL_MSG_
> +  async-prefix: ETHTOOL_MSG_
> +  list:
> +    -
> +      name: channels_get
> +      val: 17
> +      description: Get current and max supported number of channels.
> +      attribute-space: channels
> +      do:
> +        request:
> +          attributes:
> +            - header
> +        reply: &channel_reply
> +          attributes:
> +            - header
> +            - rx_max
> +            - tx_max
> +            - other_max
> +            - combined_max
> +            - rx_count
> +            - tx_count
> +            - other_count
> +            - combined_count
> +      dump:
> +        reply: *channel_reply
> +
> +    -
> +      name: channels_ntf
> +      description: Notification for device changing its number of  
> channels.
> +      notify: channels_get
> +      mcgrp: monitor
> +
> +    -
> +      name: channels_set
> +      description: Set number of channels.
> +      attribute-space: channels
> +      do:
> +        request:
> +          attributes:

[..]

> +            - header
> +            - rx_count
> +            - tx_count
> +            - other_count
> +            - combined_count

My netlink is super rusty, might be worth mentioning in the spec: these
are possible attributes, but are all of them required?

You also mention the validation part in the cover letter, do you plan
add some of these policy properties to the spec or everything is
there already? (I'm assuming we care about the types which we have above and
optional/required attribute indication?)

> +
> +mcast-groups:
> +  name-prefix: ETHTOOL_MCGRP_
> +  name-suffix: _NAME
> +  list:
> +    -
> +      name: monitor
> diff --git a/tools/net/ynl/samples/ethtool.py  
> b/tools/net/ynl/samples/ethtool.py
> new file mode 100755
> index 000000000000..63c8e29f8e5d
> --- /dev/null
> +++ b/tools/net/ynl/samples/ethtool.py
> @@ -0,0 +1,30 @@
> +#!/usr/bin/env python
> +# SPDX-License-Identifier: BSD-3-Clause
> +
> +import argparse
> +
> +from ynl import YnlFamily
> +
> +
> +def main():
> +    parser = argparse.ArgumentParser(description='YNL ethtool sample')
> +    parser.add_argument('--spec', dest='spec', type=str, required=True)
> +    parser.add_argument('--schema', dest='schema', type=str)
> +    parser.add_argument('--device', dest='dev_name', type=str)
> +    parser.add_argument('--ifindex', dest='ifindex', type=str)
> +    args = parser.parse_args()
> +
> +    ynl = YnlFamily(args.spec)
> +
> +    if args.dev_name:
> +        channels = ynl.channels_get({'header': {'dev_name':  
> args.dev_name}})
> +    elif args.ifindex:
> +        channels = ynl.channels_get({'header': {'dev_index':  
> args.ifindex}})
> +    else:
> +        return
> +    print('Netlink responded with:')
> +    print(channels)
> +
> +
> +if __name__ == "__main__":
> +    main()
> --
> 2.37.1

