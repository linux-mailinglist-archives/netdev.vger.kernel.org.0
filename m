Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 720036E6BB7
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 20:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232353AbjDRSHQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 14:07:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbjDRSHP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 14:07:15 -0400
X-Greylist: delayed 891 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 18 Apr 2023 11:07:13 PDT
Received: from smtp-p01.blackberry.com (smtp-p01.blackberry.com [208.65.78.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7288D1FFD;
        Tue, 18 Apr 2023 11:07:13 -0700 (PDT)
Received: from pps.filterd (mhs402ykf.rim.net [127.0.0.1])
        by mhs402ykf.rim.net (8.17.1.19/8.17.1.19) with ESMTP id 33IEaVeG025938;
        Tue, 18 Apr 2023 13:38:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=blackberry.com; h=date : from : to
 : cc : subject : message-id : mime-version : content-type; s=corp19;
 bh=hUjH+UcOR8+h90zgid1y9EaQTtp4ffhjogvzBY0M7S4=;
 b=bNClmIpkcOxfuAIVIvSuXe60LTmlq17pWAC3vsYoIFlq99msPYqLQo/NX5HH1DrR8Pqr
 AwOrG1t/X+LD0PSmlvOks6HKkzrHc5uqMl6iZGUugEgbICkjlghzHNik5O/O+uhP3t21
 XUwyn3aW2o7BieZkwIycDouxv84fh5/zW0e9jbkQSejLXfd/Bg5lkLfsodz1CMKibGn8
 Q3Z2xu/0yagqRFJqq6KBNJDMhJ66MzK6YIfqDtxGeuUDmoPv3ClULKY1iR1fO8xsmSvi
 WpKugrWGurkgEPBOtOsN/pUIQAgWb1kIAR3VATAkYFQAzsAidCjESIOlL8adjFm5HyGv Ig== 
Received: from mhs300ykf.rim.net (mhs300ykf.rim.net [10.12.100.129])
        by mhs402ykf.rim.net (PPS) with ESMTPS id 3pyp4wgka2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Apr 2023 13:38:26 -0400
Received: from pps.filterd (mhs300ykf.rim.net [127.0.0.1])
        by mhs300ykf.rim.net (8.17.1.19/8.17.1.19) with ESMTP id 33IFB5W1026205;
        Tue, 18 Apr 2023 13:38:26 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mhs300ykf.rim.net (PPS) with ESMTPS id 3pyrwepkre-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Apr 2023 13:38:26 -0400
Received: from mhs300ykf.rim.net (mhs300ykf.rim.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33IHcPEm021157;
        Tue, 18 Apr 2023 13:38:25 -0400
Received: from datsun.rim.net (datsun.rim.net [10.4.2.118])
        by mhs300ykf.rim.net (PPS) with ESMTPS id 3pyrwepkrc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Apr 2023 13:38:25 -0400
Received: from bspencer by datsun.rim.net with local (Exim 4.94.2)
        (envelope-from <bspencer@datsun.rim.net>)
        id 1popHd-001Dw9-0F; Tue, 18 Apr 2023 14:38:25 -0300
Date:   Tue, 18 Apr 2023 14:38:24 -0300
From:   Brad Spencer <bspencer@blackberry.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Subject: netlink getsockopt() sets only one byte?
Message-ID: <ZD7VkNWFfp22kTDt@datsun.rim.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-GUID: sCDS1fd-m7n6H24Bx4xDsEWh-qiYRP6K
X-Proofpoint-ORIG-GUID: Nk3K6GA95w1lmyFTEadlSltIHAdnaqBb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-18_13,2023-04-18_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 spamscore=0 mlxlogscore=999 phishscore=0 bulkscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304180145
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-18_13,2023-04-18_01,2023-02-09_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Calling getsockopt() on a netlink socket with SOL_NETLINK options that
use type int only sets the first byte of the int value but returns an
optlen equal to sizeof(int), at least on x86_64.


The detailed description:

It looks like netlink_getsockopt() calls put_user() with a char*
pointer, and I think that causes it to copy only one byte from the val
result, despite len being sizeof(int).

Is this the expected behaviour?  The returned size is 4, after all,
and other int-sized socket options (outside of netlink) like
SO_REUSEADDR set all bytes of the int.

Programs that do not expect this behaviour and do not initialize the
value to some known bit pattern are likely to misinterpret the result,
especially when checking to see if the value is or isn't zero.

Attached is a short program that demonstrates the issue on Arch Linux
with the 6.3.0-rc6 mainline kernel on x86_64, and also with the same
Arch Linux userland on 6.2.10-arch1-1.  I've seen the same behaviour
on older Debian and Ubuntu kernels.

    gcc -Wall -o prog prog.c
    
Show only the first byte being written to when the setting is `0`:

    $ ./progboot
    SOL_SOCKET SO_REUSEADDR:
    size=4 value=0x0
    SOL_NETLINK NETLINK_NO_ENOBUFS:
    size=4 value=0xdeadbe00
    prog: prog.c:39: tryOption: Assertion `value == 0' failed.
    Aborted (core dumped)

Workaround by initializing to zero:

    $ ./prog workaround
    SOL_SOCKET SO_REUSEADDR:
    size=4 value=0x0
    SOL_NETLINK NETLINK_NO_ENOBUFS:
    size=4 value=0x0

Show only the first byte being written to when the setting is `1`:

    $ SET_FIRST=yes ./prog
    SOL_SOCKET SO_REUSEADDR:
    size=4 value=0x1
    SOL_NETLINK NETLINK_NO_ENOBUFS:
    size=4 value=0xdeadbe01
    prog: prog.c:35: tryOption: Assertion `value == 1' failed.
    Aborted (core dumped)

Workaround by initializing to zero:

    $ SET_FIRST=yes ./prog workaround
    SOL_SOCKET SO_REUSEADDR:
    size=4 value=0x1
    SOL_NETLINK NETLINK_NO_ENOBUFS:
    size=4 value=0x1


Demonstration program:

#include <asm/types.h>
#include <assert.h>
#include <linux/netlink.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/socket.h>
#include <sys/socket.h>
#include <unistd.h>

static void tryOption(const int fd,
                      const int level,
                      const int optname,
                      const int workaround,
                      const int setFirst)
{
  assert(fd != -1);
  
  // Setting it to 1 gives similar results.
  if(setFirst)
  {
    int value = 1;
    assert(!setsockopt(fd, level, optname, &value, sizeof(value)));
  }

  // Get the option.
  {
    int value = workaround ? 0 : 0xdeadbeef;
    socklen_t size = sizeof(value);

    // Only the first byte of `value` is written to!
    assert(!getsockopt(fd, level, optname, &value, &size));
    printf("size=%u value=0x%x\n", size, value);
    if(setFirst)
    {
      assert(value == 1);
    }
    else
    {
      assert(value == 0);
    }

    // But it always reports a 4 byte option size.
    assert(size == sizeof(int));
  }

  close(fd);
}

int
main(int argc, char** argv)
{
  // If any argument is supplied, apply a workaround.
  const int workaround = argc > 1;

  // If $SET_FIRST is set to anything, set the option to 1 first.
  const int setFirst = getenv("SET_FIRST") != NULL;

  // Other int options set all bytes of the int.
  printf("SOL_SOCKET SO_REUSEADDR:\n");
  tryOption(
    socket(AF_INET, SOCK_STREAM, 0),
    SOL_SOCKET,
    SO_REUSEADDR,
    workaround,
    setFirst);

  // Netlink int socket options do not set all bytes of the int.
  printf("SOL_NETLINK NETLINK_NO_ENOBUFS:\n");
  tryOption(
    socket(AF_NETLINK, SOCK_RAW, NETLINK_ROUTE),
    SOL_NETLINK,
    NETLINK_NO_ENOBUFS,
    workaround,
    setFirst);
}

-- 
Brad Spencer

----------------------------------------------------------------------
This transmission (including any attachments) may contain confidential information, privileged material (including material protected by the solicitor-client or other applicable privileges), or constitute non-public information. Any use of this information by anyone other than the intended recipient is prohibited. If you have received this transmission in error, please immediately reply to the sender and delete this information from your system. Use, dissemination, distribution, or reproduction of this transmission by unintended recipients is not authorized and may be unlawful.
