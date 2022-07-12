Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1AD257213D
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 18:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234300AbiGLQmx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 12:42:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234182AbiGLQmj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 12:42:39 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8439B3D75
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 09:42:09 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id o7so14876565lfq.9
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 09:42:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mzZyQED/yCEHz5UyIipVTP+p+PvpvXJH6FEoNcTBy1o=;
        b=MlZmIr8BIHVkvgN3Iw/gci4iR6wj8Zg0qiOKtMGQFNs//RYw59z2AfWe1LGJYq3p/z
         j4WdrrnilN9HXAMJ7a7jJVBfB6rPexU3gOJXtyncHYmy/1xanGnoNGFbi3BWRrJnuEn0
         jZDAz6okXKqJqd4cWnLUCI0ZXlcMg6Q+qhceU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mzZyQED/yCEHz5UyIipVTP+p+PvpvXJH6FEoNcTBy1o=;
        b=LtptP4lfr8PhyVRxuDBjnZOqWm3FR8GUQMuXmLL9WR2q9bdl9kjW3QUBruVX2xVxy6
         Fn7qCuWHtqpChdoTjZlzK4NWlN8kVR8wcar/hR90rupOaKzfYJGCOeGam1tfG/Jf3DUY
         6G6Pu8jfC2pc6aEgd0UN+6ks+vAf9Tc4J2a+z8wMgwvsyGp+B8UaiMrHSvcgn/nxUlNQ
         cB94ZVJd4XMm/pIhsYlC0X0RHe+UY0zi4q9l7nCn/Am5k+OOw+PkcURSUhHxqIOSt0LB
         8YrWVjDidDIAeiKChtm3ZABQy89xBYVkLIC1uEkIP7nT5Dmzf2E+PFZSaGWhOhlZL8Jb
         QthQ==
X-Gm-Message-State: AJIora8WIuxkvWxBX1gH0kgOsvhe8zNU/laYgoZaQYSnUjrbXWT3TqVy
        Y8xZ3Ysv6+0bXCsfDa7q31vloXShImYCuONWnMcdnw==
X-Google-Smtp-Source: AGRyM1ti2YwZ/fkLc45ZFgDFkVmzWapuTADrgvw14AQzoXbY0+raMlUHYzrjoE5kAUDOGOEFUHisOJbXs1Uin1a2l/0=
X-Received: by 2002:a19:2d04:0:b0:482:e88a:b933 with SMTP id
 k4-20020a192d04000000b00482e88ab933mr16266885lfj.533.1657644121817; Tue, 12
 Jul 2022 09:42:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220628164241.44360-1-vikas.gupta@broadcom.com>
 <20220707182950.29348-1-vikas.gupta@broadcom.com> <20220707182950.29348-2-vikas.gupta@broadcom.com>
 <YswaKcUs6nOndU2V@nanopsycho> <CAHLZf_t9ihOQPvcQa8cZsDDVUX1wisrBjC30tHG_-Dz13zg=qQ@mail.gmail.com>
 <Ys0UpFtcOGWjK/sZ@nanopsycho>
In-Reply-To: <Ys0UpFtcOGWjK/sZ@nanopsycho>
From:   Vikas Gupta <vikas.gupta@broadcom.com>
Date:   Tue, 12 Jul 2022 22:11:49 +0530
Message-ID: <CAHLZf_s7s4rqBkDnB+KH-YJRDBDzeZB6VhKMMndk+dxxY11h3g@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/3] devlink: introduce framework for selftests
To:     Jiri Pirko <jiri@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, dsahern@kernel.org,
        stephen@networkplumber.org, Eric Dumazet <edumazet@google.com>,
        pabeni@redhat.com, ast@kernel.org, leon@kernel.org,
        linux-doc@vger.kernel.org, corbet@lwn.net,
        Michael Chan <michael.chan@broadcom.com>,
        Andrew Gospodarek <andrew.gospodarek@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000014795105e39e59ad"
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000014795105e39e59ad
Content-Type: text/plain; charset="UTF-8"

Hi Jiri,

On Tue, Jul 12, 2022 at 11:58 AM Jiri Pirko <jiri@nvidia.com> wrote:
>
> Tue, Jul 12, 2022 at 08:16:11AM CEST, vikas.gupta@broadcom.com wrote:
> >Hi Jiri,
> >
> >On Mon, Jul 11, 2022 at 6:10 PM Jiri Pirko <jiri@nvidia.com> wrote:
> >
> >> Thu, Jul 07, 2022 at 08:29:48PM CEST, vikas.gupta@broadcom.com wrote:
> >> >Add a framework for running selftests.
> >> >Framework exposes devlink commands and test suite(s) to the user
> >> >to execute and query the supported tests by the driver.
> >> >
> >> >Below are new entries in devlink_nl_ops
> >> >devlink_nl_cmd_selftests_show: To query the supported selftests
> >> >by the driver.
> >> >devlink_nl_cmd_selftests_run: To execute selftests. Users can
> >> >provide a test mask for executing group tests or standalone tests.
> >> >
> >> >Documentation/networking/devlink/ path is already part of MAINTAINERS &
> >> >the new files come under this path. Hence no update needed to the
> >> >MAINTAINERS
> >> >
> >> >Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
> >> >Reviewed-by: Michael Chan <michael.chan@broadcom.com>
> >> >Reviewed-by: Andy Gospodarek <andrew.gospodarek@broadcom.com>
> >> >---
> >> > .../networking/devlink/devlink-selftests.rst  |  34 +++++
> >> > include/net/devlink.h                         |  30 ++++
> >> > include/uapi/linux/devlink.h                  |  26 ++++
> >> > net/core/devlink.c                            | 144 ++++++++++++++++++
> >> > 4 files changed, 234 insertions(+)
> >> > create mode 100644 Documentation/networking/devlink/devlink-selftests.rst
> >> >
> >> >diff --git a/Documentation/networking/devlink/devlink-selftests.rst
> >> b/Documentation/networking/devlink/devlink-selftests.rst
> >> >new file mode 100644
> >> >index 000000000000..796d38f77038
> >> >--- /dev/null
> >> >+++ b/Documentation/networking/devlink/devlink-selftests.rst
> >> >@@ -0,0 +1,34 @@
> >> >+.. SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> >> >+
> >> >+=================
> >> >+Devlink Selftests
> >> >+=================
> >> >+
> >> >+The ``devlink-selftests`` API allows executing selftests on the device.
> >> >+
> >> >+Tests Mask
> >> >+==========
> >> >+The ``devlink-selftests`` command should be run with a mask indicating
> >> >+the tests to be executed.
> >> >+
> >> >+Tests Description
> >> >+=================
> >> >+The following is a list of tests that drivers may execute.
> >> >+
> >> >+.. list-table:: List of tests
> >> >+   :widths: 5 90
> >> >+
> >> >+   * - Name
> >> >+     - Description
> >> >+   * - ``DEVLINK_SELFTEST_FLASH``
> >> >+     - Runs a flash test on the device.
> >> >+
> >> >+example usage
> >> >+-------------
> >> >+
> >> >+.. code:: shell
> >> >+
> >> >+    # Query selftests supported on the device
> >> >+    $ devlink dev selftests show DEV
> >> >+    # Executes selftests on the device
> >> >+    $ devlink dev selftests run DEV test {flash | all}
> >> >diff --git a/include/net/devlink.h b/include/net/devlink.h
> >> >index 2a2a2a0c93f7..cb7c378cf720 100644
> >> >--- a/include/net/devlink.h
> >> >+++ b/include/net/devlink.h
> >> >@@ -1215,6 +1215,18 @@ enum {
> >> >       DEVLINK_F_RELOAD = 1UL << 0,
> >> > };
> >> >
> >> >+#define DEVLINK_SELFTEST_FLASH_TEST_NAME "flash"
> >> >+
> >> >+static inline const char *devlink_selftest_name(int test)
> >>
> >> I don't understand why this is needed. Better not to expose string to
> >> the user. Just have it as well defined attr.
> >
> >
> > OK. Will remove this function and corresponding attr
> >DEVLINK_ATTR_TEST_NAME added in this patch.
> >
> >
> >
> >
> >>
> >> >+{
> >> >+      switch (test) {
> >> >+      case DEVLINK_SELFTEST_FLASH_BIT:
> >> >+              return DEVLINK_SELFTEST_FLASH_TEST_NAME;
> >> >+      default:
> >> >+              return "unknown";
> >> >+      }
> >> >+}
> >> >+
> >> > struct devlink_ops {
> >> >       /**
> >> >        * @supported_flash_update_params:
> >> >@@ -1509,6 +1521,24 @@ struct devlink_ops {
> >> >                                   struct devlink_rate *parent,
> >> >                                   void *priv_child, void *priv_parent,
> >> >                                   struct netlink_ext_ack *extack);
> >> >+      /**
> >> >+       * selftests_show() - Shows selftests supported by device
> >> >+       * @devlink: Devlink instance
> >> >+       * @extack: extack for reporting error messages
> >> >+       *
> >> >+       * Return: test mask supported by driver
> >> >+       */
> >> >+      u32 (*selftests_show)(struct devlink *devlink,
> >> >+                            struct netlink_ext_ack *extack);
> >> >+      /**
> >> >+       * selftests_run() - Runs selftests
> >> >+       * @devlink: Devlink instance
> >> >+       * @tests_mask: tests to be run by driver
> >> >+       * @results: test results by driver
> >> >+       * @extack: extack for reporting error messages
> >> >+       */
> >> >+      void (*selftests_run)(struct devlink *devlink, u32 tests_mask,
> >> >+                            u8 *results, struct netlink_ext_ack *extack);
> >> > };
> >> >
> >> > void *devlink_priv(struct devlink *devlink);
> >> >diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
> >> >index b3d40a5d72ff..1dba262328b9 100644
> >> >--- a/include/uapi/linux/devlink.h
> >> >+++ b/include/uapi/linux/devlink.h
> >> >@@ -136,6 +136,9 @@ enum devlink_command {
> >> >       DEVLINK_CMD_LINECARD_NEW,
> >> >       DEVLINK_CMD_LINECARD_DEL,
> >> >
> >> >+      DEVLINK_CMD_SELFTESTS_SHOW,
> >> >+      DEVLINK_CMD_SELFTESTS_RUN,
> >> >+
> >> >       /* add new commands above here */
> >> >       __DEVLINK_CMD_MAX,
> >> >       DEVLINK_CMD_MAX = __DEVLINK_CMD_MAX - 1
> >> >@@ -276,6 +279,25 @@ enum {
> >> > #define DEVLINK_SUPPORTED_FLASH_OVERWRITE_SECTIONS \
> >> >       (_BITUL(__DEVLINK_FLASH_OVERWRITE_MAX_BIT) - 1)
> >> >
> >> >+/* Commonly used test cases */
> >> >+enum {
> >> >+      DEVLINK_SELFTEST_FLASH_BIT,
> >> >+
> >> >+      __DEVLINK_SELFTEST_MAX_BIT,
> >> >+      DEVLINK_SELFTEST_MAX_BIT = __DEVLINK_SELFTEST_MAX_BIT - 1
> >> >+};
> >> >+
> >> >+#define DEVLINK_SELFTEST_FLASH _BITUL(DEVLINK_SELFTEST_FLASH_BIT)
> >> >+
> >> >+#define DEVLINK_SELFTESTS_MASK \
> >> >+      (_BITUL(__DEVLINK_SELFTEST_MAX_BIT) - 1)
> >> >+
> >> >+enum {
> >> >+      DEVLINK_SELFTEST_SKIP,
> >> >+      DEVLINK_SELFTEST_PASS,
> >> >+      DEVLINK_SELFTEST_FAIL
> >> >+};
> >> >+
> >> > /**
> >> >  * enum devlink_trap_action - Packet trap action.
> >> >  * @DEVLINK_TRAP_ACTION_DROP: Packet is dropped by the device and a copy
> >> is not
> >> >@@ -576,6 +598,10 @@ enum devlink_attr {
> >> >       DEVLINK_ATTR_LINECARD_TYPE,             /* string */
> >> >       DEVLINK_ATTR_LINECARD_SUPPORTED_TYPES,  /* nested */
> >> >
> >> >+      DEVLINK_ATTR_SELFTESTS_MASK,            /* u32 */
> >>
> >> I don't see why this is u32 bitset. Just have one attr per test
> >> (NLA_FLAG) in a nested attr instead.
> >>
> >
> >As per your suggestion, for an example it should be like as below
> >
> >        DEVLINK_ATTR_SELFTESTS,                 /* nested */
> >
> >        DEVLINK_ATTR_SELFTESTS_SOMETEST1            /* flag */
> >
> >        DEVLINK_ATTR_SELFTESTS_SOMETEST2           /* flag */
>
> Yeah, but have the flags in separate enum, no need to pullute the
> devlink_attr enum by them.
>
>
> >
> >....    <SOME MORE TESTS>
> >
> >.....
> >
> >        DEVLINK_ATTR_SLEFTESTS_RESULT_VAL,      /* u8 */
> >
> >
> >
> > If we have this way then we need to have a mapping (probably a function)
> >for drivers to tell them what tests need to be executed based on the flags
> >that are set.
> > Does this look OK?
> >  The rationale behind choosing a mask is that we could directly pass the
> >mask-value to the drivers.
>
> If you have separate enum, you can use the attrs as bits internally in
> kernel. Add a helper that would help the driver to work with it.
> Pass a struct containing u32 (or u8) not to drivers. Once there are more
> tests than that, this structure can be easily extended and the helpers
> changed. This would make this scalable. No need for UAPI change or even
> internel driver api change.

As per your suggestion, selftest attributes can be declared in separate
enum as below

enum {

        DEVLINK_SELFTEST_SOMETEST,         /* flag */

        DEVLINK_SELFTEST_SOMETEST1,

        DEVLINK_SELFTEST_SOMETEST2,

....

......

        __DEVLINK_SELFTEST_MAX,

        DEVLINK_SELFTEST_MAX = __DEVLINK_SELFTEST_MAX - 1

};
Below  examples could be the flow of parameters/data from user to
kernel and vice-versa


Kernel to user for show command . Users can know what all tests are
supported by the driver. A return from kernel to user.
______
|NEST |
|_____ |TEST1|TEST4|TEST7|...


User to kernel to execute test: If user wants to execute test4, test8, test1...
______
|NEST |
|_____ |TEST4|TEST8|TEST1|...


Result Kernel to user execute test RES(u8)
______
|NEST |
|_____ |RES4|RES8|RES1|...

Results are populated in the same order as the user passed the TESTs
flags. Does the above result format from kernel to user look OK ?
Else we need to have below way to form a result format, a nest should
be made for <test_flag,
result> but since test flags are in different enum other than
devlink_attr and RES being part of devlink_attr, I believe it's not
good practice to make the below structure.
______
|NEST |
|_____ | TEST4, RES4|TEST8,RES8|TEST1,RES1|...

Let me know if my understanding is correct.

Thanks,
Vikas

>
>
> >
> >
> >>
> >>
> >>
> >> >+      DEVLINK_ATTR_TEST_RESULT,               /* nested */
> >> >+      DEVLINK_ATTR_TEST_NAME,                 /* string */
> >> >+      DEVLINK_ATTR_TEST_RESULT_VAL,           /* u8 */
> >>
> >> Could you maintain the same "namespace" for all attrs related to
> >> selftests?
> >>
> >
> >Will fix it.
> >
> >
> >>
> >> >       /* add new attributes above here, update the policy in devlink.c */
> >> >
> >> >       __DEVLINK_ATTR_MAX,
> >> >diff --git a/net/core/devlink.c b/net/core/devlink.c
> >> >index db61f3a341cb..0b7341ab6379 100644
> >> >--- a/net/core/devlink.c
> >> >+++ b/net/core/devlink.c
> >> >@@ -4794,6 +4794,136 @@ static int devlink_nl_cmd_flash_update(struct
> >> sk_buff *skb,
> >> >       return ret;
> >> > }
> >> >
> >> >+static int devlink_selftest_name_put(struct sk_buff *skb, int test)
> >> >+{
> >> >+      const char *name = devlink_selftest_name(test);
> >> >+      if (nla_put_string(skb, DEVLINK_ATTR_TEST_NAME, name))
> >> >+              return -EMSGSIZE;
> >> >+
> >> >+      return 0;
> >> >+}
> >> >+
> >> >+static int devlink_nl_cmd_selftests_show(struct sk_buff *skb,
> >> >+                                       struct genl_info *info)
> >> >+{
> >> >+      struct devlink *devlink = info->user_ptr[0];
> >> >+      struct sk_buff *msg;
> >> >+      unsigned long tests;
> >> >+      int err = 0;
> >> >+      void *hdr;
> >> >+      int test;
> >> >+
> >> >+      if (!devlink->ops->selftests_show)
> >> >+              return -EOPNOTSUPP;
> >> >+
> >> >+      msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
> >> >+      if (!msg)
> >> >+              return -ENOMEM;
> >> >+
> >> >+      hdr = genlmsg_put(msg, info->snd_portid, info->snd_seq,
> >> >+                        &devlink_nl_family, 0,
> >> DEVLINK_CMD_SELFTESTS_SHOW);
> >> >+      if (!hdr)
> >> >+              goto free_msg;
> >> >+
> >> >+      if (devlink_nl_put_handle(msg, devlink))
> >> >+              goto genlmsg_cancel;
> >> >+
> >> >+      tests = devlink->ops->selftests_show(devlink, info->extack);
> >> >+
> >> >+      for_each_set_bit(test, &tests, __DEVLINK_SELFTEST_MAX_BIT) {
> >> >+              err = devlink_selftest_name_put(msg, test);
> >> >+              if (err)
> >> >+                      goto genlmsg_cancel;
> >> >+      }
> >> >+
> >> >+      genlmsg_end(msg, hdr);
> >> >+
> >> >+      return genlmsg_reply(msg, info);
> >> >+
> >> >+genlmsg_cancel:
> >> >+      genlmsg_cancel(msg, hdr);
> >> >+free_msg:
> >> >+      nlmsg_free(msg);
> >> >+      return err;
> >> >+}
> >> >+
> >> >+static int devlink_selftest_result_put(struct sk_buff *skb, int test,
> >> >+                                     u8 result)
> >> >+{
> >> >+      const char *name = devlink_selftest_name(test);
> >> >+      struct nlattr *result_attr;
> >> >+
> >> >+      result_attr = nla_nest_start_noflag(skb, DEVLINK_ATTR_TEST_RESULT);
> >> >+      if (!result_attr)
> >> >+              return -EMSGSIZE;
> >> >+
> >> >+      if (nla_put_string(skb, DEVLINK_ATTR_TEST_NAME, name) ||
> >> >+          nla_put_u8(skb, DEVLINK_ATTR_TEST_RESULT_VAL, result))
> >> >+              goto nla_put_failure;
> >> >+
> >> >+      nla_nest_end(skb, result_attr);
> >> >+
> >> >+      return 0;
> >> >+
> >> >+nla_put_failure:
> >> >+      nla_nest_cancel(skb, result_attr);
> >> >+      return -EMSGSIZE;
> >> >+}
> >> >+
> >> >+static int devlink_nl_cmd_selftests_run(struct sk_buff *skb,
> >> >+                                      struct genl_info *info)
> >> >+{
> >> >+      u8 test_results[DEVLINK_SELFTEST_MAX_BIT + 1] = {};
> >> >+      struct devlink *devlink = info->user_ptr[0];
> >> >+      unsigned long tests;
> >> >+      struct sk_buff *msg;
> >> >+      u32 tests_mask;
> >> >+      void *hdr;
> >> >+      int err = 0;
> >> >+      int test;
> >> >+
> >> >+      if (!devlink->ops->selftests_run)
> >> >+              return -EOPNOTSUPP;
> >> >+
> >> >+      if (!info->attrs[DEVLINK_ATTR_SELFTESTS_MASK])
> >> >+              return -EINVAL;
> >> >+
> >> >+      msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
> >> >+      if (!msg)
> >> >+              return -ENOMEM;
> >> >+
> >> >+      hdr = genlmsg_put(msg, info->snd_portid, info->snd_seq,
> >> >+                        &devlink_nl_family, 0,
> >> DEVLINK_CMD_SELFTESTS_RUN);
> >> >+      if (!hdr)
> >> >+              goto free_msg;
> >> >+
> >> >+      if (devlink_nl_put_handle(msg, devlink))
> >> >+              goto genlmsg_cancel;
> >> >+
> >> >+      tests_mask = nla_get_u32(info->attrs[DEVLINK_ATTR_SELFTESTS_MASK]);
> >> >+
> >> >+      devlink->ops->selftests_run(devlink, tests_mask, test_results,
> >>
> >> Why don't you run it 1 by 1 and fill up the NL message 1 by 1 too?
> >>
> >>      I`ll consider it in the next patch set.
>
> Please do. This array of results returned from driver looks sloppy.
>
>
> >
> >
> >>
> >> >+                                  info->extack);
> >> >+      tests = tests_mask;
> >> >+
> >> >+      for_each_set_bit(test, &tests, __DEVLINK_SELFTEST_MAX_BIT) {
> >> >+              err = devlink_selftest_result_put(msg, test,
> >> >+                                                test_results[test]);
> >> >+              if (err)
> >> >+                      goto genlmsg_cancel;
> >> >+      }
> >> >+
> >> >+      genlmsg_end(msg, hdr);
> >> >+
> >> >+      return genlmsg_reply(msg, info);
> >> >+
> >> >+genlmsg_cancel:
> >> >+      genlmsg_cancel(msg, hdr);
> >> >+free_msg:
> >> >+      nlmsg_free(msg);
> >> >+      return err;
> >> >+}
> >> >+
> >> > static const struct devlink_param devlink_param_generic[] = {
> >> >       {
> >> >               .id = DEVLINK_PARAM_GENERIC_ID_INT_ERR_RESET,
> >> >@@ -9000,6 +9130,8 @@ static const struct nla_policy
> >> devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
> >> >       [DEVLINK_ATTR_RATE_PARENT_NODE_NAME] = { .type = NLA_NUL_STRING },
> >> >       [DEVLINK_ATTR_LINECARD_INDEX] = { .type = NLA_U32 },
> >> >       [DEVLINK_ATTR_LINECARD_TYPE] = { .type = NLA_NUL_STRING },
> >> >+      [DEVLINK_ATTR_SELFTESTS_MASK] = NLA_POLICY_MASK(NLA_U32,
> >> >+
> >> DEVLINK_SELFTESTS_MASK),
> >> > };
> >> >
> >> > static const struct genl_small_ops devlink_nl_ops[] = {
> >> >@@ -9361,6 +9493,18 @@ static const struct genl_small_ops
> >> devlink_nl_ops[] = {
> >> >               .doit = devlink_nl_cmd_trap_policer_set_doit,
> >> >               .flags = GENL_ADMIN_PERM,
> >> >       },
> >> >+      {
> >> >+              .cmd = DEVLINK_CMD_SELFTESTS_SHOW,
> >> >+              .validate = GENL_DONT_VALIDATE_STRICT |
> >> GENL_DONT_VALIDATE_DUMP,
> >> >+              .doit = devlink_nl_cmd_selftests_show,
> >>
> >> Why don't dump?
> >>
> >
> >  I`ll add a dump in the next patchset.
> >
> >Thanks,
> >Vikas
> >
> >
> >>
> >>
> >> >+              .flags = GENL_ADMIN_PERM,
> >> >+      },
> >> >+      {
> >> >+              .cmd = DEVLINK_CMD_SELFTESTS_RUN,
> >> >+              .validate = GENL_DONT_VALIDATE_STRICT |
> >> GENL_DONT_VALIDATE_DUMP,
> >> >+              .doit = devlink_nl_cmd_selftests_run,
> >> >+              .flags = GENL_ADMIN_PERM,
> >> >+      },
> >> > };
> >> >
> >> > static struct genl_family devlink_nl_family __ro_after_init = {
> >> >--
> >> >2.31.1
> >> >
> >>
> >>
> >>
>
>

--00000000000014795105e39e59ad
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
I7qKxvF8Yo7eGTnHRTa99J+6yTd88AKVuhM5TEhpC8cS7qvrQXJje+Uing2xWC4FH76LEWIFH0Pt
x8C1WoCU0ClXHU/XfzH2mYrFANBSCeP1Co6QdEfRAgMBAAGjggHZMIIB1TAOBgNVHQ8BAf8EBAMC
BaAwgaMGCCsGAQUFBwEBBIGWMIGTME4GCCsGAQUFBzAChkJodHRwOi8vc2VjdXJlLmdsb2JhbHNp
Z24uY29tL2NhY2VydC9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcnQwQQYIKwYBBQUHMAGG
NWh0dHA6Ly9vY3NwLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwME0G
A1UdIARGMEQwQgYKKwYBBAGgMgEoCjA0MDIGCCsGAQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxz
aWduLmNvbS9yZXBvc2l0b3J5LzAJBgNVHRMEAjAAMEkGA1UdHwRCMEAwPqA8oDqGOGh0dHA6Ly9j
cmwuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3JsMCMGA1UdEQQc
MBqBGHZpa2FzLmd1cHRhQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNVHSME
GDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUUc6J11rH3s6PyZQ0zIVZHIuP20Yw
DQYJKoZIhvcNAQELBQADggEBALvCjXn9gy9a2nU/Ey0nphGZefIP33ggiyuKnmqwBt7Wk/uDHIIc
kkIlqtTbo0x0PqphS9A23CxCDjKqZq2WN34fL5MMW83nrK0vqnPloCaxy9/6yuLbottBY4STNuvA
mQ//Whh+PE+DZadqiDbxXbos3IH8AeFXH4A1zIqIrc0Um2/CSD/T6pvu9QrchtvemfP0z/f1Bk+8
QbQ4ARVP93WV1I13US69evWXw+mOv9VnejShU9PMcDK203xjXbBOi9Hm+fthrWfwIyGoC5aEf7vd
PKkEDt4VZ9RbudZU/c3N8+kURaHNtrvu2K+mQs5w/AF7HYZThqmOzQJnvMRjuL8xggJtMIICaQIB
ATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQDEyhH
bG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwYjepatB64S625eswwDQYJ
YIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIMW7j/56oRK9m5Unw4CJZ8kJV7AoKya8leYd
QciXI19qMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDcxMjE2
NDIwMlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCGSAFl
AwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATAN
BgkqhkiG9w0BAQEFAASCAQCbWshErB8soPQASTLdeV91Wn0LG0RAKtidjCTN4BCTJsRBOJsQUYKf
NVbeFhZ9ZdaBKbOKCAJ5o+e+c1JXDl6rJShzTwq/GY9dWsawlED+zryw4PN2y6LNm5HIcGF4tWyD
uSSvncvmfZczKbR9n59ovoydf8xWKJm3gADHVpVvvdNDsuSwdekt/7Sew7eVyn1nksRcqnV2VoyQ
ufDLs8gnMFzERAo05vkU7Cai/vJGi2a72QVZhO1MdAV+Y46EsozinzvXRklPswBg/LVQ20ggePzC
98eWqsDNbowPguIFPZYnL0WoGT88My2xZ7SX1biD2qJEtmXLJtTU3UC126bm
--00000000000014795105e39e59ad--
